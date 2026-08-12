# SQL Data Warehouse & Analytics Project

Portfolio project · Complete Data Warehouse with Medallion Architecture (Bronze, Silver, Gold)
Based on the [Data With Baraa](https://www.youtube.com/@datawithbaraa) project, adapted for PostgreSQL / DBeaver / Linux Mint.

---

## 🎯 Why This Project

After finishing SQL fundamentals (DDL, DML, JOIN, Set Operations, functions, subqueries, CTE, Window Functions, VIEW, INDEX), this project is my first full application: building a real Data Warehouse from scratch, with a professional architecture, before moving on to Python.

My path: **Data Analyst → Data Engineer → Data Science Foundations → ML Data Engineer → MLOps**
This project is the first concrete building block of the Data Engineering part.

---

## 🏗️ Data Architecture

This project follows the **Medallion Architecture** — Bronze, Silver, Gold:

```
Sources (CSV: ERP + CRM)
        ↓
   BRONZE LAYER    → raw data, as-is, no transformation
        ↓
   SILVER LAYER    → cleaning, standardization, normalization
        ↓
   GOLD LAYER      → star schema, ready for analytics
```

| Layer | Definition | Object Type | Load Method | Transformation |
|---|---|---|---|---|
| 🟤 Bronze | Raw data from sources | Tables | Full Load (Truncate & Insert) | None |
| ⚪ Silver | Cleaned and standardized data | Tables | Full Load (Truncate & Insert) | Cleaning, Standardization, Normalization, Derived Columns, Enrichment |
| 🟡 Gold | Business-ready data | Views | None (computed views) | Integration, Aggregation, Business Rules |

---

## 🛠️ Tools Used (Linux-adapted version)

| Tool (Baraa) | My equivalent |
|---|---|
| SQL Server Express | **PostgreSQL** (installed on Linux Mint) |
| SSMS | **DBeaver Community Edition** |
| DrawIO | DrawIO (web version, works the same on Linux) |
| GitHub | GitHub |
| Notion | Obsidian (already used for my SQL notes) |

---

## 📖 What This Project Demonstrates

1. **Data Architecture** — designing a modern Data Warehouse with Bronze/Silver/Gold layers
2. **ETL Pipeline** — extracting, transforming, and loading data from source systems into the warehouse
3. **Data Modeling** — building fact and dimension tables (star schema)
4. **Analytics & Reporting** — business-oriented SQL queries (customer behavior, product performance, sales trends)

Skills demonstrated: Advanced SQL · Data Architecture · Data Engineering · ETL · Data Modeling · Data Analytics

---

## 🚀 Project Objectives

### Part 1 — Building the Data Warehouse (Data Engineering)

**Objective**: develop a modern Data Warehouse using PostgreSQL to consolidate sales data and enable reliable analytical reporting.

**Specifications**:
- **Sources**: import data from two systems (ERP and CRM), provided as CSV files
- **Data Quality**: clean and resolve data quality issues before analysis
- **Integration**: combine both sources into a single, clear data model designed for analysis
- **Scope**: focus on the most recent data only; historization (SCD2) is not required for this V1
- **Documentation**: clear documentation of the data model, understandable by both business and data teams

### Part 2 — Analytics & Reporting (Data Analysis)

**Objective**: develop detailed SQL analytics on:
- **Customer Behavior**
- **Product Performance**
- **Sales Trends**

---

## 📂 Repository Structure

```
sql-data-warehouse-project/
│
├── datasets/                       # Raw project data (ERP and CRM)
│
├── docs/                           # Documentation and architecture
│   ├── data_architecture.png       # Medallion architecture diagram
│   ├── etl.drawio                  # ETL techniques diagram
│   ├── data_catalog.md             # Table and column catalog
│   ├── data_flow.drawio            # Data flow diagram
│   ├── data_models.drawio          # Star schema
│   └── naming-conventions.md       # Naming conventions
│
├── scripts/                        # SQL scripts for ETL and transformations
│   ├── bronze/                     # Raw extraction and loading
│   ├── silver/                     # Cleaning and transformation
│   └── gold/                       # Analytical models (views)
│
├── tests/                          # Test scripts and quality checks
│
├── README.md                       # This file
└── .gitignore
```

---

## 📊 Progress

- [x] Phase 1 — Solid SQL (JOIN, subqueries, CTE, Window Functions, VIEW, INDEX)
- [ ] Architecture design (docs/data_architecture)
- [ ] Bronze Layer — ERP + CRM CSV ingestion
- [ ] Silver Layer — cleaning and standardization
- [ ] Gold Layer — star schema + views
- [ ] Analytical reports (customer behavior, product, trends)
- [ ] Full documentation

---

## 🔗 Related Projects

- **Career Insight** — my personal project analyzing the Data job market in Algeria
- This project (Data Warehouse) is a guided exercise to solidify fundamentals before building my own pipelines on Career Insight in Phase 4

---

## 🙏 Credits

Project based on the tutorial by **Baraa Khatib Salkini** ([Data With Baraa](https://www.youtube.com/@datawithbaraa)) — adapted and personalized for a PostgreSQL / Linux Mint environment as part of my Data Analyst → MLOps Engineer journey.
