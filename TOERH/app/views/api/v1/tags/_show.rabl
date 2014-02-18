
node(:self) { |t| request.base_url + v1_tag_path(t.public_id) }

attributes :public_id => :id
attributes :name
attributes :created_at => :createdAt