# SSIS ETL PROJECT

## Business Scenario
XYZ Corp stores customer purchase transactions in local currencies, while currency exchange rates and customer contact information 
are maintained in separate files. 
This fragmented data structure makes it difficult to perform centralized reporting and customer analysis.

Purchase data is stored in SQL Server, 
exchange rates are maintained in an Excel file, 
and customer contact details are stored in a CSV file.

**The objective of this project is to use SSIS to integrate these data sources, convert purchase amounts into a standard reporting currency, enrich the data with customer contact information, and load the consolidated results into a new SQL Server database for reporting and analysis.**
---

The project will cover the following SSIS fundamentals:
  - Introduction to SSIS and its role in ETL processes
  - Installing and configuring SQL Server Data Tools (SSDT)
  - Understanding SSIS architecture:
    - Control Flow
    - Data Flow
  - Creating an SSIS package from scratch
  - Using common SSIS tasks and components
  - Connecting to multiple data sources and destinations
  - Applying basic data transformations
  - Handling errors and data quality issues
  - Using variables and parameters
  - Deploying SSIS packages to the SSIS Catalog (SSISDB)
  - Scheduling SSIS packages using SQL Server Agent
  - Applying SSIS best practices
  - Debugging and troubleshooting SSIS packages

---

## Requirements
To run this project, you need:

- **SQL Server Developer / Standard / Enterprise Edition**
- **SQL Server Integration Services (SSIS)**
- **SQL Server Data Tools (SSDT)**
- **SQL Server Management Studio (SSMS)**
- **Microsoft Visual Studio Community / Enterprise** for development and testing.

> Note: SQL Server Express does **not** support SSIS.

---



