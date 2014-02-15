object @resource

node(:self) { v1_resources(@resource) }

attributes :public_id => :id
attributes :name, :description, :url
attributes :created_at => :createdAt
attributes :updated_at => :updatedAt

child :user do
  	attributes :public_id => :id
	attributes :firstname, :lastname, :email
end

child :resource_type do
	extends "resource_types/_show"
end

child :license do
	extends "licenses/_show"
end