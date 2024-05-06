from pyspark.sql.types import *
from pyspark.sql import SparkSession
# from pyspark.sql.types import StructType, StructField, IntegerType

import pyspark.sql.functions as f

def load_edges(spark_session, file_path, num_partitions=10):
    schema_1 = StructType(fields=[
        StructField('out', IntegerType(), False),
        StructField('in', IntegerType(), False)
    ])
    edges = spark_session.read.option("sep", "\t").schema(schema_1).csv(file_path)
    return edges.coalesce(num_partitions)

def load_paths(spark_session, data, num_partitions=10):
    schema_2 = StructType(fields=[
        StructField('end', IntegerType(), False),
        StructField('path', StringType(), False)
    ])
    paths = spark_session.createDataFrame(data, schema=schema_2)
    return paths.coalesce(num_partitions)

spark = SparkSession.builder.appName('gimishjanas_task2_df').master('yarn').getOrCreate()

edges = load_edges(spark, '/data/twitter/twitter_sample.txt')
paths_data = [[12, '12']]
paths = load_paths(spark, paths_data)

for _ in range(100):
    paths = paths.join(edges, paths['end'] == edges['in'], 'inner')
    paths = paths.select(f.col('out').alias('end'),
                         f.concat_ws(',', paths['path'], paths['out']).alias('path'))

    count = paths.filter(paths['end'] == 34).count()
    if count > 0:
        break
        
end, path = paths.filter(paths['end'] == 34).first()
print(path)
