class CreateLicenses < ActiveRecord::Migration
  def change
    create_table :licenses do |t|
			
      t.string "public_id", :null => false, :limit => 50
			t.string "name", :limit => 100, :null => false
    	t.text "description", :limit => 2000, :null => true
    	t.string "url", :limit => 200, :null => true
    	
      t.timestamps
    end
  end
end
