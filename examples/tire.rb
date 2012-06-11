index = Tire.index("bbs")
index.delete
index.regist_shard(6)

p index.shard_info

mapping = {"csdn"=> {"_source"=>{"enabled"=>false},
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
        {"type"=>"integer", "index"=>"not_analyzed", "include_in_all"=>false}
    }
  }
}

index.create_mapping("csdn", mapping)

p index.mapping("csdn")

doc = [
  {"title"=>"java 是好东西",
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
    "username"=>"william"}
]

index.bulk("csdn", doc)

index.flush
index.refresh

search = Tire.search("bbs", "csdn", '{"query":{"text":{"title":"java"}},"size":10,"from":0}')
p search.results