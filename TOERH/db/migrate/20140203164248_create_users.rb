class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|

    	t.string "firstname", :null => false, :limit => 40
    	t.string "lastname", :null => false, :limit => 40
    	t.string "email", :null => false, :limit => 40
    	t.string "password_digest", :null => false

      t.references :user_role, :null => false, :default => 1

      t.timestamps
    end
  end
end
