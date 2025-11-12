-- Skapa databaser om de saknas
IF DB_ID(N'LIA_DB_Bronze')   IS NULL CREATE DATABASE [LIA_DB_Bronze];
IF DB_ID(N'LIA_DB_Silver')   IS NULL CREATE DATABASE [LIA_DB_Silver];
IF DB_ID(N'LIA_DW_Gold')  IS NULL CREATE DATABASE [LIA_DW_Gold];
IF DB_ID(N'LIA_DB_Diagnostics') IS NULL CREATE DATABASE [LIA_DB_Diagnostics];