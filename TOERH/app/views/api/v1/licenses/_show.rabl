
node(:self) { |l| request.base_url + v1_license_path(l.public_id) }

attributes :public_id => :id
attributes :name, :description, :url
attributes :created_at => :createdAt
attributes :updated_at => :updatedAt