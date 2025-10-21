/* LIA_DB_Silver – drop valda tabeller med FK-hantering
   Inkluderar: Bridge.RegionGroup,
   dbo.HICPTarget, dbo.HICPTarget_In,
   Dim.* (alla i bilden),
   Fact.* (alla i bilden),
   rej.* (alla i bilden)
*/
USE [LIA_DB_Silver];
SET NOCOUNT ON;
SET XACT_ABORT ON;

/* 1) Lista måltabeller */
DECLARE @Targets TABLE (SchemaName sysname, TableName sysname);

INSERT INTO @Targets (SchemaName, TableName) VALUES
-- rej
('rej','BridgeRegionGroup'),('rej','ConfigGroup'),('rej','HICPTarget'),
-- Bridge
('Bridge','RegionGroup'),
-- Fact
('Fact','Employment'),('Fact','GDP'),('Fact','GovernmentDebt'),
('Fact','HICPIndex'),('Fact','JobVacancies'),
('Fact','MoneyMarketInterestRates'),('Fact','Population'),
('Fact','Unemployment'),
-- Dim
('Dim','AgeClassEmp'),('Dim','AgeClassUnemp'),('Dim','ConfigGroup'),
('Dim','ConsumptionCategory'),('Dim','Date'),('Dim','Flags'),
('Dim','Gender'),('Dim','Region'),('Dim','SeasonalAdjustment'),
('Dim','TimeFrequency'),('Dim','Unit'),
-- dbo
('dbo','HICPTarget'),('dbo','HICPTarget_In');

/* 2) Droppa alla FKs som antingen sitter på eller refererar till måltabellerna */
DECLARE @sqlFK nvarchar(max) =
(
    SELECT STRING_AGG(
        CONCAT('ALTER TABLE ', QUOTENAME(OBJECT_SCHEMA_NAME(fk.parent_object_id)),
               '.', QUOTENAME(OBJECT_NAME(fk.parent_object_id)),
               ' DROP CONSTRAINT ', QUOTENAME(fk.name), ';'),
        CHAR(10)
    )
    FROM sys.foreign_keys fk
    WHERE
        -- FK sitter på en av våra tabeller
        (EXISTS (
            SELECT 1
            FROM @Targets t
            WHERE t.SchemaName = OBJECT_SCHEMA_NAME(fk.parent_object_id)
              AND t.TableName  = OBJECT_NAME(fk.parent_object_id)
        )
        -- eller FK refererar en av våra tabeller
        OR EXISTS (
            SELECT 1
            FROM @Targets t
            WHERE t.SchemaName = OBJECT_SCHEMA_NAME(fk.referenced_object_id)
              AND t.TableName  = OBJECT_NAME(fk.referenced_object_id)
        ))
);

BEGIN TRAN;

IF @sqlFK IS NOT NULL AND LEN(@sqlFK) > 0
    EXEC sp_executesql @sqlFK;

-- 3) Droppa tabeller i logisk ordning: rej -> Bridge -> Fact -> Dim -> dbo
-- (IF EXISTS säkrar mot saknade objekt)
-- rej
DROP TABLE IF EXISTS rej.BridgeRegionGroup;
DROP TABLE IF EXISTS rej.ConfigGroup;
DROP TABLE IF EXISTS rej.HICPTarget;

-- Bridge
DROP TABLE IF EXISTS Bridge.RegionGroup;

-- Fact
DROP TABLE IF EXISTS Fact.Employment;
DROP TABLE IF EXISTS Fact.GDP;
DROP TABLE IF EXISTS Fact.GovernmentDebt;
DROP TABLE IF EXISTS Fact.HICPIndex;
DROP TABLE IF EXISTS Fact.JobVacancies;
DROP TABLE IF EXISTS Fact.MoneyMarketInterestRates;
DROP TABLE IF EXISTS Fact.Population;
DROP TABLE IF EXISTS Fact.Unemployment;

-- Dim
DROP TABLE IF EXISTS Dim.AgeClassEmp;
DROP TABLE IF EXISTS Dim.AgeClassUnemp;
DROP TABLE IF EXISTS Dim.ConfigGroup;
DROP TABLE IF EXISTS Dim.ConsumptionCategory;
DROP TABLE IF EXISTS Dim.Date;
DROP TABLE IF EXISTS Dim.Flags;
DROP TABLE IF EXISTS Dim.Gender;
DROP TABLE IF EXISTS Dim.Region;
DROP TABLE IF EXISTS Dim.SeasonalAdjustment;
DROP TABLE IF EXISTS Dim.TimeFrequency;
DROP TABLE IF EXISTS Dim.Unit;

-- dbo
DROP TABLE IF EXISTS dbo.HICPTarget;
DROP TABLE IF EXISTS dbo.HICPTarget_In;

COMMIT;

PRINT 'Klart: Tabeller + beroende FKs i LIA_DB_Silver droppade.';
