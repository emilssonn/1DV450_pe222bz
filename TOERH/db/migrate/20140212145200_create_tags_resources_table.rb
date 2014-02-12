class CreateTagsResourcesTable < ActiveRecord::Migration
  def change
    create_table :tags_resources, :id => false do |t|

    	t.references :tag, :null => false
    	t.references :resource, :null => false

    end

    add_index(:tags_resources, [:tag_id, :resource_id], unique: true)
  end
end
