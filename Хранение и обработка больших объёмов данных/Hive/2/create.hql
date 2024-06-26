ADD jar /opt/cloudera/parcels/CDH/lib/hive/lib/json-serde-1.3.8-jar-with-dependencies.jar;

SET hive.cli.print.header=false;
SET mapred.input.dir.recursive=true;
SET hive.mapred.supports.subdirectories=true;

USE gimishjanas;

DROP TABLE IF EXISTS kkt_transactions_text;
CREATE TABLE kkt_transactions_text 
STORED AS TEXTFILE
AS 
    SELECT 
        content.userInn AS user, 
        content.totalSum AS userSum 
    FROM 
        kkt_transactions_1 
    WHERE 
        subtype = "receipt";

DROP TABLE IF EXISTS kkt_transactions_orc;
CREATE TABLE kkt_transactions_orc 
STORED AS ORC
AS 
    SELECT 
        content.userInn AS user, 
        content.totalSum AS userSum 
    FROM 
        kkt_transactions_1 
    WHERE 
        subtype = "receipt";

DROP TABLE IF EXISTS kkt_transactions_parquet;
CREATE TABLE kkt_transactions_parquet 
STORED AS PARQUET
AS 
    SELECT 
        content.userInn AS user, 
        content.totalSum AS userSum 
    FROM 
        kkt_transactions_1 
    WHERE 
        subtype = "receipt";

DROP TABLE IF EXISTS kkt_transactions_results;
CREATE EXTERNAL TABLE kkt_transactions_results (
    formatType STRING,
    time STRING
);
INSERT INTO TABLE kkt_transactions_results
VALUES 
    ('Text', '45.44s'), 
    ('ORC', '44.15s'), 
    ('Parquet', '50.21s');

