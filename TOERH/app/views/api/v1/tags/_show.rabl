object @tag

node(:self) { v1_tags(@tag) }

attributes :public_id => :id
attributes :name
attributes :created_at => :createdAt