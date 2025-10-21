/* LIA_DB_Bronze – drop Raw.* tabeller
   Kör i rätt databas (LIA_DB_Bronze) */
USE [LIA_DB_Bronze];
SET NOCOUNT ON;
SET XACT_ABORT ON;

BEGIN TRAN;

-- Droppa tabeller (var och en är "IF EXISTS"-säkrad)
DROP TABLE IF EXISTS Raw.ConfigGroup;
DROP TABLE IF EXISTS Raw.Employment;
DROP TABLE IF EXISTS Raw.GDP;
DROP TABLE IF EXISTS Raw.GovernmentDebt;
DROP TABLE IF EXISTS Raw.HICPIndex;
DROP TABLE IF EXISTS Raw.HICPTarget;
DROP TABLE IF EXISTS Raw.JobVacancies;
DROP TABLE IF EXISTS Raw.MoneyMarketInterestRates;
DROP TABLE IF EXISTS Raw.Population;
DROP TABLE IF EXISTS Raw.RegionGroupBridge;
DROP TABLE IF EXISTS Raw.Unemployment;

COMMIT;
PRINT 'Klart: Raw-tabeller droppade.';
