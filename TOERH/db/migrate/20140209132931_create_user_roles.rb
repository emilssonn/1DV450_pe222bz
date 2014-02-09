class CreateUserRoles < ActiveRecord::Migration
  def change
    create_table :user_roles do |t|

    	t.string "name", :limit => 30, :null => false
    	
    end
  end
end
