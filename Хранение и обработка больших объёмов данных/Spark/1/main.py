from pyspark import SparkContext, SparkConf

def parse_edge(s):
    user, follower = map(int, s.split("\t"))
    return user, follower

def step(item):
    prev_v, path, next_v = item[0], item[1][0], item[1][1]
    return (next_v, path + ',' + str(next_v))

conf = SparkConf().setAppName("gimishjanas_task1_rdd").setMaster("yarn")
sc = SparkContext(conf=conf)

n = 10  # number of partitions
edges = sc.textFile("/data/twitter/twitter_sample.txt").map(parse_edge)
forward_edges = edges.map(lambda e: (e[1], e[0])).partitionBy(n).persist()

start = 12
end = 34
max_path_len = 100
paths = sc.parallelize([(start, str(start))]).partitionBy(n)

# Find the path
for _ in range(max_path_len):
    paths = paths.join(forward_edges).flatMap(step)
    paths.cache()
    if paths.filter(lambda x: x[0] == end).count() > 0:
        break

# Retrieve the path
end, path = paths.filter(lambda x: x[0] == end).first()
print(path)

