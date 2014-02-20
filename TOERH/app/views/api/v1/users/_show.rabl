
node(:self) { |u| request.base_url + v1_user_path(u.public_id) }

attributes :public_id => :id
attributes :firstname, :lastname, :email
attributes :created_at => :joined