class CreateResourcesTags < ActiveRecord::Migration
  def change
    create_table :resources_tags, :id => false do |t|
    	
    	t.references :tag, :null => false
    	t.references :resource, :null => false

    end

    add_index(:resources_tags, [:tag_id, :resource_id], unique: true)
  end
end
