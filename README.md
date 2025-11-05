# LIA Macroeconomics – Data Warehouse & Analytics

**LIA_Makroekonomi** is a project I am developing during my LIA (internship) period.  The goal is to build a structured data warehouse focused on macro‑economic indicators. By collecting raw data from public sources (like Eurostat), transforming it through SQL Server Integration Services (SSIS) and visualizing it in Power BI, we create a foundation for analysing indicators such as GDP, employment, unemployment and price indexes.

The project follows a **medallion architecture**, where data flows through multiple layers with progressively improved quality.  Databricks describes this model as organising data into layers (Bronze ⇒ Silver ⇒ Gold) to improve the structure and quality.

* **Bronze (raw data)** – this is where all data lands from external sources.  The tables in this layer mirror the source “as is”, with additional metadata capturing load date/time and process ID.
* **Silver (cleaned and conformed data)** – in this layer, data from the Bronze layer is matched, merged, deduplicated and cleaned.  The goal is a unified enterprise view where duplicates are eliminated and units are normalised.
* **Gold (curated business tables)** – the final presentation layer.  Here the data is organised into star schemas or data marts optimised for reporting and analytics.

## Repository structure

The main directories in this repository are:

| Directory | Contents |
| --- | --- |
| **`DB_Bronze`** | SSIS packages for landing and storing raw data in the bronze layer.  This is where tables mirroring the external sources are created and all loads are logged. |
| **`DB_Silver/DB_Silver`** | SSIS project with packages for the silver layer.  These packages clean, normalise and deduplicate data and build dimension tables (e.g. `Dim.Date`, `Dim.Region`, `Dim.Unit`, `Dim.Gender`, `Dim.SeasonalAdjustment`, `Dim.TimeFrequency`, `Dim.Flags`) as well as fact tables for indices and labour‑market statistics. |
| **`DW_Gold`** | SSIS packages that create and load a data warehouse (star schema) in the gold layer.  Includes packages for dimensions (`Dim.Date`, `Dim.Region`, `Dim.Unit`, etc.) and fact tables such as `Fact.GDP.dtsx` (GDP), `Fact.Employment.dtsx` (employment), `Fact.Unemployment.dtsx` (unemployment), `Fact.HICPIndex.dtsx` (harmonised price index), `Fact.HICPTarget.dtsx`, etc.  There are also packages to create tables and run the entire load chain. |
| **`Power BI – Makroekonomi (pbip)`** | Contains Power BI projects (PBIP format) for the primary macroeconomics report.  Includes the semantic model (`Makroekonomi.SemanticModel`) and TMDL scripts defining measures, relationships and calculations. |
| **`Power BI – Loggar (pbip)`** | A separate Power BI report that analyses load logs from the ETL processes to monitor data quality and errors. |
| **`LIA_Makroekonomi`** | Visual Studio solution and project files (.sln, .dtproj) that consolidate the SSIS projects.  Also contains upgrade logs from the development environment. |

## Prerequisites

To run the project you need:

1. **SQL Server and SSIS** – install SQL Server (Express/Developer) and SQL Server Integration Services.  Visual Studio with SQL Server Integration Services (SSIS) is required to open and run the SSIS packages.
2. **Data sources** – access to macro‑economic data sources, e.g. Eurostat’s API.  You can customise the source databases in the bronze layer as needed.
3. **Power BI Desktop (version 2023 or later)** – required to open the PBIP projects and build the reports.
4. **.NET/Visual Studio** – to build and maintain the Visual Studio projects.

## Getting started

1. **Clone the repository**:

   ```bash
   git clone https://github.com/TobiasAnalytica/LIA_Makroekonomi.git
   cd LIA_Makroekonomi
