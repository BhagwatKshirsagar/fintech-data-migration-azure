-- Run this query before setting up SynapseServerless Linkedin Service
-- In SynapseServerless Linkedin Service use ReadExternalDataDB as database

CREATE DATABASE ReadExternalDataDB; 

CREATE EXTERNAL DATA SOURCE FintechDataExternal
WITH (
    LOCATION = 'https://<your_storage_account>.dfs.core.windows.net/<container_name>'
);

--If not working with above two queries try with below queries 
CREATE MASTER KEY
ENCRYPTION BY PASSWORD = 'Your password';

CREATE DATABASE SCOPED CREDENTIAL WorkspaceIdentity
WITH IDENTITY = 'Managed Identity';

DROP EXTERNAL DATA SOURCE FintechDataExternal;
GO

CREATE EXTERNAL DATA SOURCE FintechDataExternal
WITH (
    LOCATION = 'https://fintechrg.dfs.core.windows.net/fintech',
    CREDENTIAL = WorkspaceIdentity
);

SELECT
    name,
    credential_id
FROM sys.external_data_sources;

SELECT COUNT(*)
FROM OPENROWSET(
    BULK 'bronze/fintech/Loans/*.parquet',
    DATA_SOURCE = 'FintechDataExternal',
    FORMAT = 'PARQUET'
) AS rows;