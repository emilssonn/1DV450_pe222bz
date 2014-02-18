
node(:self) { |r| request.base_url + v1_resource_type_path(r.public_id) }

attributes :public_id => :id
attributes :name, :description
attributes :created_at => :createdAt
attributes :updated_at => :updatedAt