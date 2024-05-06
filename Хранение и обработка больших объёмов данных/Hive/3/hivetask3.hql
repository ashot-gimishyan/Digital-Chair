ADD jar /opt/cloudera/parcels/CDH/lib/hive/lib/json-serde-1.3.8-jar-with-dependencies.jar;

SET hive.cli.print.header=false;
SET mapred.input.dir.recursive=true;
SET hive.mapred.supports.subdirectories=true;

USE gimishjanas;

CREATE TABLE transact_sums
AS SELECT content.userInn as user, DAY(from_unixtime(CAST(content.dateTime.ddate/1000 as BIGINT), 'yyyy-MM-dd')) as date, COALESCE(content.totalSum, 0) as userSum FROM kkt_transactions_1
SORT BY user, date;

CREATE TABLE daily_s
AS SELECT user, date, sum(userSum) as daySum FROM transact_sums
GROUP BY user, date;

CREATE TABLE maximum_s
AS SELECT user, max(daySum) as maxSum FROM daily_s
GROUP BY user;

SELECT daily_s.user, daily_s.date, daily_s.daySum
FROM daily_s INNER JOIN maximum_s
ON daily_s.user = maximum_s.user AND daily_s.daySum = maximum_s.maxSum;
