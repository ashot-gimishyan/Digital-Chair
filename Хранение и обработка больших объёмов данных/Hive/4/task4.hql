ADD jar /opt/cloudera/parcels/CDH/lib/hive/lib/json-serde-1.3.8-jar-with-dependencies.jar;

SET hive.cli.print.header=false;
SET mapred.input.dir.recursive=true;
SET hive.mapred.supports.subdirectories=true;

USE gimishjanas;

WITH evening_sums AS (
    SELECT content.userInn as user, AVG(COALESCE(content.totalSum, 0)) as avgEveningSum
    FROM kkt_transactions_1
    WHERE HOUR(from_unixtime(CAST(content.dateTime.ddate/1000 as BIGINT))) >= 13
    GROUP BY content.userInn
),
morning_sums AS (
    SELECT content.userInn as user, AVG(COALESCE(content.totalSum, 0)) as avgMorningSum
    FROM kkt_transactions_1
    WHERE HOUR(from_unixtime(CAST(content.dateTime.ddate/1000 as BIGINT))) < 13
    GROUP BY content.userInn
)

SELECT avg_evening_sums.user,
       ROUND(avg_morning_sums.avgMorningSum) as avgMorningSum,
       ROUND(avg_evening_sums.avgEveningSum) as avgEveningSum
FROM evening_sums avg_evening_sums
INNER JOIN morning_sums avg_morning_sums
ON avg_evening_sums.user = avg_morning_sums.user
WHERE avg_morning_sums.avgMorningSum > avg_evening_sums.avgEveningSum
ORDER BY avgMorningSum
LIMIT 50;
