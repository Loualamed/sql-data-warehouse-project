# Data Warehouse Project

## 📌 Overview

This project is a data warehouse built with **PostgreSQL** and managed using **DBeaver**.

The goal of this project is to practice fundamental data warehousing concepts, including:

* Data ingestion
* Data cleaning
* Data transformation
* Data integration
* Data modeling

The project follows the **Bronze, Silver, and Gold architecture**.

---

## 🏗️ Architecture

* **Bronze** — Raw data loaded from source systems.
* **Silver** — Cleaned and transformed data.
* **Gold** — Business-ready data used for analysis and reporting.

---

## 📂 Project Structure

```text
DataWarehouse/
│
├── README.md
│
├── scripts/
│   ├── bronze/
│   ├── silver/
│   └── gold/
│
├── datasets/
│   ├── source_crm/
│   └── source_erp/
│
├── test/
│   ├── quality_checks_silver.sql
│   └── quality_checks_gold.sql
│
└── docs/
    └── data_catalog.md
```

---

## 🗄️ Data Sources

The project uses data from two source systems:

* **CRM** — Customer and sales information.
* **ERP** — Additional customer, location, and product information.

The data is loaded into the Bronze layer and progressively transformed through the Silver and Gold layers.

---

## 🥉 Bronze Layer

The Bronze layer stores the raw data imported from the source CSV files.

---

## 🥈 Silver Layer

The Silver layer contains cleaned and transformed data.

Main operations include:

* Data cleaning
* Standardization
* Handling invalid and missing values
* Integration of CRM and ERP data

---

## 🥇 Gold Layer

The Gold layer contains the final analytical model.

It includes:

* `gold.dim_customers`
* `gold.dim_products`
* `gold.fact_sales`

The model follows a **star-schema structure** with customer and product dimensions connected to the sales fact.

---

## 🧪 Data Quality Tests

SQL tests are included to check the quality of the Silver and Gold layers.

* `test/quality_checks_silver.sql`
* `test/quality_checks_gold.sql`

These tests help verify data quality, consistency, duplicates, NULL values, and relationships between tables.

---

## 🛠️ Technologies

* PostgreSQL
* SQL
* DBeaver
* Git & GitHub
* CSV

---

## 🚀 Setup

1. Create the PostgreSQL database.
2. Create the `bronze`, `silver`, and `gold` schemas.
3. Run the scripts in the `scripts/` directory.
4. Load the datasets.
5. Run the Silver transformations.
6. Create the Gold views.
7. Run the quality checks from the `test/` directory.

---

## 🎯 Project Goal

This project was created as a practical exercise to understand the fundamentals of building a data warehouse with PostgreSQL, from raw data ingestion to a business-ready analytical model.
