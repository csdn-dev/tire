Tire
=========
Ruby client for ElasticSearch.

Usage
-----

注册分片：
```
[1] pry(main)> index = Tire.index("index_name")
=> #<Tire::Index:0x9cd1564 @name="index_name">
[2] pry(main)> index.regist_shard(6)
# 2012-06-05 16:23:44:053 [_regist_shard] ("index_name")
#
curl -X PUT "http://192.168.6.35:9400/index_name/_shard" -d '{"cs1":[0,2,4],"cs2":[1,3,5]}'

# 2012-06-05 16:23:44:053 [200]

=> true
[3] pry(main)> 
```

查看分片信息：
```
[2] pry(main)> index.shard_info
# 2012-06-05 16:25:40:748 [_regist_shard_info] ("index_name")
#
curl -X GET http://192.168.6.35:9400/index_name

# 2012-06-05 16:25:40:748 [200]

=> [{"host"=>"127.0.0.1:9400", "index"=>"index_name", "shardId"=>0},
 {"host"=>"127.0.0.1:9500", "index"=>"index_name", "shardId"=>1},
 {"host"=>"127.0.0.1:9400", "index"=>"index_name", "shardId"=>2},
 {"host"=>"127.0.0.1:9500", "index"=>"index_name", "shardId"=>3},
 {"host"=>"127.0.0.1:9400", "index"=>"index_name", "shardId"=>4},
 {"host"=>"127.0.0.1:9500", "index"=>"index_name", "shardId"=>5}]

```
