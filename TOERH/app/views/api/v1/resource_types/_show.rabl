object @resource_type

node(:self) { v1_resource_types(@resource_type) }

attributes :public_id => :id
attributes :name, :description
attributes :updated_at => :updatedAt