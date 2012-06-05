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

删除索引(后端未实现)：

```
[5] pry(main)> index.delete
# 2012-06-05 17:07:02:158 [DELETE] ("index_name")
#
curl -X DELETE http://192.168.6.35:9400/index_name

# 2012-06-05 17:07:02:158 [200]

=> true

```

创建Mapping

```
[1] pry(main)> options_str = '{"csdn" : {
[1] pry(main)*          "_source" : { "enabled" : false },
[1] pry(main)*          "properties" : {
[1] pry(main)*              "title":           {"type" : "string","term_vector":"with_positions_offsets","boost":2.0},
[1] pry(main)*              "body":            {"type" : "string","term_vector":"with_positions_offsets"},
[1] pry(main)*              "username":        {"type" : "string","index":"not_analyzed","store":"no"},
[1] pry(main)*              "id" :             {"type" : "integer","index":"not_analyzed","include_in_all":false},
[1] pry(main)*              "created_at" :     {"type" : "integer","index":"not_analyzed","include_in_all":false}
[1] pry(main)*          }}}'
=> "{\"csdn\" : {\n         \"_source\" : { \"enabled\" : false },\n         \"properties\" : {\n             \"title\":           {\"type\" : \"string\",\"term_vector\":\"with_positions_offsets\",\"boost\":2.0},\n             \"body\":            {\"type\" : \"string\",\"term_vector\":\"with_positions_offsets\"},\n             \"username\":        {\"type\" : \"string\",\"index\":\"not_analyzed\",\"store\":\"no\"},\n             \"id\" :             {\"type\" : \"integer\",\"index\":\"not_analyzed\",\"include_in_all\":false},\n             \"created_at\" :     {\"type\" : \"integer\",\"index\":\"not_analyzed\",\"include_in_all\":false}\n         }}}"
[2] pry(main)> options_json = '{"csdn" : {
[2] pry(main)*          "_source" : { "enabled" : false },
[2] pry(main)*          "properties" : {
[2] pry(main)*              "title":           {"type" : "string","term_vector":"with_positions_offsets","boost":2.0},
[2] pry(main)*              "body":            {"type" : "string","term_vector":"with_positions_offsets"},
[2] pry(main)*              "username":        {"type" : "string","index":"not_analyzed","store":"no"},
[2] pry(main)*              "id" :             {"type" : "integer","index":"not_analyzed","include_in_all":false},
[2] pry(main)*              "created_at" :     {"type" : "integer","index":"not_analyzed","include_in_all":false}
[2] pry(main)*          }}}'
=> "{\"csdn\" : {\n         \"_source\" : { \"enabled\" : false },\n         \"properties\" : {\n             \"title\":           {\"type\" : \"string\",\"term_vector\":\"with_positions_offsets\",\"boost\":2.0},\n             \"body\":            {\"type\" : \"string\",\"term_vector\":\"with_positions_offsets\"},\n             \"username\":        {\"type\" : \"string\",\"index\":\"not_analyzed\",\"store\":\"no\"},\n             \"id\" :             {\"type\" : \"integer\",\"index\":\"not_analyzed\",\"include_in_all\":false},\n             \"created_at\" :     {\"type\" : \"integer\",\"index\":\"not_analyzed\",\"include_in_all\":false}\n         }}}"
[3] pry(main)> options_hash = JSON.parse options_json
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

[5] pry(main)> index = Tire.index("index_name")
=> #<Tire::Index:0xab7799c @name="index_name">
[7] pry(main)> index.create_mapping("csdn", options_hash)
# 2012-06-05 17:36:06:237 [CREATE MAPPING] ("index_name")
#
curl -X PUT http://192.168.6.35:9400/index_name/csdn/_mapping -d '{"csdn":{"_source":{"enabled":false},"properties":{"title":{"type":"string","term_vector":"with_positions_offsets","boost":2.0},"body":{"type":"string","term_vector":"with_positions_offsets"},"username":{"type":"string","index":"not_analyzed","store":"no"},"id":{"type":"integer","index":"not_analyzed","include_in_all":false},"created_at":{"type":"integer","index":"not_analyzed","include_in_all":false}}}}'

# 2012-06-05 17:36:06:237 [200]

=> true
```
