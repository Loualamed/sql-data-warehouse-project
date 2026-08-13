/*
=============================================================
Create Database and Schemas
=============================================================
Script Purpose:
    This script creates the DataWarehouse database and
    the bronze, silver, and gold schemas.

Before running this script:
    Connect to PostgreSQL from the Bash terminal using either
    a PostgreSQL user with permission to create databases or
    the default PostgreSQL administrator.

    psql -h localhost -U <your_username> -d postgres

    or

    sudo -u postgres psql

WARNING:
    Make sure that a database named DataWarehouse does not
    already exist before running this script.
*/

CREATE DATABASE DataWarehouse;

\c datawarehouse

CREATE SCHEMA bronze;
CREATE SCHEMA silver;
CREATE SCHEMA gold;
