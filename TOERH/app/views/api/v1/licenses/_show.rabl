object @license

node(:self) { v1_licenses(@license) }

attributes :public_id => :id
attributes :name, :description, :url
attributes :updated_at => :updatedAt