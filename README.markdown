Tire
=========
Ruby client for ElasticSearch.

Usage
-----

配置：

```
# 设置搜索后端节点数量：
Tire::Configuration.nodes_count(2)
```

```
# 设置日志：
Tire::Configuration.logger(STDOUT, :level => "debug")
```

```
# 设置搜索后端URL
Tire::Configuration.url("http://localhost:9200")
```
或者在环境变量设置：
```
export ELASTICSEARCH_URL=http://localhost:9200
```

注册分片：index.regist_shard(total)
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

查看分片信息：index.shard_info
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

删除索引：index.delete

```
[5] pry(main)> index.delete
# 2012-06-05 17:07:02:158 [DELETE] ("index_name")
#
curl -X DELETE http://192.168.6.35:9400/index_name

# 2012-06-05 17:07:02:158 [200]

=> true

```

创建Mapping:index.create_mapping(type, options)

```
[4] pry(main)> mapping = {"csdn"=>
[4] pry(main)*   {"_source"=>{"enabled"=>false},
[4] pry(main)*     "properties"=>
[4] pry(main)*     {"title"=>
[4] pry(main)*       {"type"=>"string",
[4] pry(main)*         "term_vector"=>"with_positions_offsets",
[4] pry(main)*       "boost"=>2.0},
[4] pry(main)*       "body"=>{"type"=>"string", "term_vector"=>"with_positions_offsets"},
[4] pry(main)*       "username"=>{"type"=>"string", "index"=>"not_analyzed", "store"=>"no"},
[4] pry(main)*       "id"=>
[4] pry(main)*       {"type"=>"integer", "index"=>"not_analyzed", "include_in_all"=>false},
[4] pry(main)*       "created_at"=>
[4] pry(main)* {"type"=>"integer", "index"=>"not_analyzed", "include_in_all"=>false}}}}
=> {"csdn"=>
  {"_source"=>{"enabled"=>false},
   "properties"=>
    {"title"=>
      {"type"=>"string",
       "term_vector"=>"with_positions_offsets",
       "boost"=>2.0},
     "body"=>{"type"=>"string", "term_vector"=>"with_positions_offsets"},
     "username"=>{"type"=>"string", "index"=>"not_analyzed", "store"=>"no"},
     "id"=>
      {"type"=>"integer", "index"=>"not_analyzed", "include_in_all"=>false},
     "created_at"=>
      {"type"=>"integer", "index"=>"not_analyzed", "include_in_all"=>false}}}}
[6] pry(main)> index.create_mapping("csdn", mapping)
# 2012-06-06 13:22:25:504 [CREATE MAPPING] ("index_name")
#
curl -X PUT http://192.168.6.35:9400/index_name/csdn/_mapping -d '{"csdn":{"_source":{"enabled":false},"properties":{"title":{"type":"string","term_vector":"with_positions_offsets","boost":2.0},"body":{"type":"string","term_vector":"with_positions_offsets"},"username":{"type":"string","index":"not_analyzed","store":"no"},"id":{"type":"integer","index":"not_analyzed","include_in_all":false},"created_at":{"type":"integer","index":"not_analyzed","include_in_all":false}}}}'

# 2012-06-06 13:22:25:505 [200]

=> true
```

查看Mapping:index.mapping(type)

```
[1] pry(main)> index = Tire.index("index_name")
=> #<Tire::Index:0x89f22cc @name="index_name">
[2] pry(main)> index.mapping
index.mapping
[2] pry(main)> index.mapping("csdn")
=> {"csdn"=>
  {"_source"=>{"enabled"=>false},
   "properties"=>
    {"title"=>
      {"type"=>"string",
       "term_vector"=>"with_positions_offsets",
       "boost"=>2.0},
     "body"=>{"type"=>"string", "term_vector"=>"with_positions_offsets"},
     "username"=>{"type"=>"string", "index"=>"not_analyzed", "store"=>"no"},
     "id"=>
      {"type"=>"integer", "index"=>"not_analyzed", "include_in_all"=>false},
     "created_at"=>
      {"type"=>"integer", "index"=>"not_analyzed", "include_in_all"=>false}}}}
[3] pry(main)>

```

批量提交索引数据：index.bulk(type, doc)

```
[14] pry(main)> doc = <<-EOF
[14] pry(main)* [
[14] pry(main)*   {"title":"java 是好东西","body":"hey java","id":"1","username":"jack","created_at":2007072323},
[14] pry(main)*   {"title":"this java cool","body":"hey java","id":"2","created_at":2009072323,"username":"robbin"},
[14] pry(main)*   {"title":"this is java cool","body":"hey java","id":"3","created_at":2010072323,"username":"www"},
[14] pry(main)*   {"title":"java is really cool","body":"hey java","id":"4","created_at":2007062323,"username":"google"},
[14] pry(main)*   {"title":"this is wakak cool","body":"hey java","id":"5","created_at":2007062323,"username":"jackde"},
[14] pry(main)*   {"title":"this is java cool","body":"hey java","id":"6","created_at":2007012323,"username":"jackk wa"},
[14] pry(main)*   {"title":"this java really cool","body":"hey java","id":"7","created_at":2002072323,"username":"william"}
[14] pry(main)* ]
[14] pry(main)* EOF
=> "[\n  {\"title\":\"java 是好东西\",\"body\":\"hey java\",\"id\":\"1\",\"username\":\"jack\",\"created_at\":2007072323},\n  {\"title\":\"this java cool\",\"body\":\"hey java\",\"id\":\"2\",\"created_at\":2009072323,\"username\":\"robbin\"},\n  {\"title\":\"this is java cool\",\"body\":\"hey java\",\"id\":\"3\",\"created_at\":2010072323,\"username\":\"www\"},\n  {\"title\":\"java is really cool\",\"body\":\"hey java\",\"id\":\"4\",\"created_at\":2007062323,\"username\":\"google\"},\n  {\"title\":\"this is wakak cool\",\"body\":\"hey java\",\"id\":\"5\",\"created_at\":2007062323,\"username\":\"jackde\"},\n  {\"title\":\"this is java cool\",\"body\":\"hey java\",\"id\":\"6\",\"created_at\":2007012323,\"username\":\"jackk wa\"},\n  {\"title\":\"this java really cool\",\"body\":\"hey java\",\"id\":\"7\",\"created_at\":2002072323,\"username\":\"william\"}\n]\n"
[15] pry(main)> hash_doc = JSON.parse doc
=> [{"title"=>"java 是好东西",
  "body"=>"hey java",
  "id"=>"1",
  "username"=>"jack",
  "created_at"=>2007072323},
 {"title"=>"this java cool",
  "body"=>"hey java",
  "id"=>"2",
  "created_at"=>2009072323,
  "username"=>"robbin"},
 {"title"=>"this is java cool",
  "body"=>"hey java",
  "id"=>"3",
  "created_at"=>2010072323,
  "username"=>"www"},
 {"title"=>"java is really cool",
  "body"=>"hey java",
  "id"=>"4",
  "created_at"=>2007062323,
  "username"=>"google"},
 {"title"=>"this is wakak cool",
  "body"=>"hey java",
  "id"=>"5",
  "created_at"=>2007062323,
  "username"=>"jackde"},
 {"title"=>"this is java cool",
  "body"=>"hey java",
  "id"=>"6",
  "created_at"=>2007012323,
  "username"=>"jackk wa"},
 {"title"=>"this java really cool",
  "body"=>"hey java",
  "id"=>"7",
  "created_at"=>2002072323,
  "username"=>"william"}]
[16] pry(main)> index
=> #<Tire::Index:0xa809bd4
 @name="index_name",
 @options=
  {"csdn"=>
    {"_source"=>{"enabled"=>false},
     "properties"=>
      {"title"=>
        {"type"=>"string",
         "term_vector"=>"with_positions_offsets",
         "boost"=>2.0},
       "body"=>{"type"=>"string", "term_vector"=>"with_positions_offsets"},
       "username"=>{"type"=>"string", "index"=>"not_analyzed", "store"=>"no"},
       "id"=>
        {"type"=>"integer", "index"=>"not_analyzed", "include_in_all"=>false},
       "created_at"=>
        {"type"=>"integer",
         "index"=>"not_analyzed",
         "include_in_all"=>false}}}},
 @response=200 : {"ok":true,"acknowledged":true}>
[17] pry(main)> index.bulk("csdn", hash_doc)
# 2012-06-06 13:35:54:133 [BULK] ("index_name")
#
curl -X PUT http://192.168.6.35:9400/index_name/csdn/_pulk -d '[{"title":"java 是好东西","body":"hey java","id":"1","username":"jack","created_at":2007072323},{"title":"this java cool","body":"hey java","id":"2","created_at":2009072323,"username":"robbin"},{"title":"this is java cool","body":"hey java","id":"3","created_at":2010072323,"username":"www"},{"title":"java is really cool","body":"hey java","id":"4","created_at":2007062323,"username":"google"},{"title":"this is wakak cool","body":"hey java","id":"5","created_at":2007062323,"username":"jackde"},{"title":"this is java cool","body":"hey java","id":"6","created_at":2007012323,"username":"jackk wa"},{"title":"this java really cool","body":"hey java","id":"7","created_at":2002072323,"username":"william"}]'

# 2012-06-06 13:35:54:133 [200]

=> true
```

持久化索引：index.flush

```
[2] pry(main)> index.flush
# 2012-06-06 14:44:23:782 [FLUSH] ("index_name")
#
curl -X PUT http://192.168.6.35:9400/index_name/_flush

# 2012-06-06 14:44:23:782 [200]

=> true
```

刷新索引：index.refresh

```
[3] pry(main)> index.refresh
# 2012-06-06 14:44:29:085 [REFRESH] ("index_name")
#
curl -X PUT http://192.168.6.35:9400/index_name/_refresh

# 2012-06-06 14:44:29:085 [200]

=> true
```

搜索：Tire.search(index, type, payload)

```
search = Tire.search("bbs", "csdn", '{"query":{"text":{"title":"java"}},"size":10,"from":0}')
=> #<Tire::Search:0xb34e5328
 @indices=["bbs"],
 @path="/bbs/csdn/_search",
 @payload="{\"query\":{\"text\":{\"title\":\"java\"}},\"size\":10,\"from\":0}",
 @types=["csdn"]>
[28] pry(main)> search.results
# 2012-06-11 14:34:37:%L [_search] (["bbs"])
#
curl -X GET http://192.168.6.35:9400/bbs/csdn/_search -d '{"query":{"text":{"title":"java"}},"size":10,"from":0}'

# 2012-06-11 14:34:37:%L [200] (N/A msec)

```

统计：

```
count = Tire.count("bbs", "csdn", '{"query":{"text":{"title":"java"}},"size":10,"from":0}')
=> #<Tire::Count:0xb34b2860
 @indices=["bbs"],
 @path="/bbs/csdn/_count",
 @payload="{\"query\":{\"text\":{\"title\":\"java\"}},\"size\":10,\"from\":0}",
 @types=["csdn"]>
[27] pry(main)> p count.results
# 2012-06-11 15:41:05:%L [_search] (["bbs"])
#
curl -X GET http://192.168.6.35:9400/bbs/csdn/_count -d '{"query":{"text":{"title":"java"}},"size":10,"from":0}'

# 2012-06-11 15:41:05:%L [200] (N/A msec)
#
# {
#   "totalHits": 6
# }

6
```