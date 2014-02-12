class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|

    	t.string "public_id", :null => false, :limit => 50
    	t.string "name", :limit => 20, :null => false
      t.timestamps
    end

    add_index(:tags, :name, unique: true)
  end
end
