class CreateResourceTypes < ActiveRecord::Migration
  def change
    create_table :resource_types do |t|

    	t.string "public_id", :null => false, :limit => 50
    	t.string "name", :limit => 50, :null => false
    	t.text "description", :limit => 500, :null => true

      t.timestamps
    end
  end
end
