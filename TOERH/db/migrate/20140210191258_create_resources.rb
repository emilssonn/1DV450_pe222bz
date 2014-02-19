class CreateResources < ActiveRecord::Migration
  def change
    create_table :resources do |t|

      t.string "public_id", :null => false, :limit => 50
    	t.references :resource_type, :null => false
    	t.references :user, :null => false
    	t.references :license, :null => false

    	t.string "name", :limit => 100, :null => false
    	t.text "description", :limit => 2000, :null => false
    	t.string "url", :limit => 200, :null => false
    	
      t.timestamps
    end
  end
end
