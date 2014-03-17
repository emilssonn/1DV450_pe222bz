
node(:self) { |r| request.base_url + v1_resource_path(r.public_id) }

attributes :public_id => :id
attributes :name, :description, :url
attributes :created_at => :createdAt
attributes :updated_at => :updatedAt

child :user do
  	extends "api/v1/users/_show"
end

child :resource_type => :resourceType do
	extends "api/v1/resource_types/_show"
end

child :license do
	extends "api/v1/licenses/_show"
end

node :tags do |r|
	r.tags.map(&:name)
end