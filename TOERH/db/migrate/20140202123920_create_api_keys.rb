class CreateApiKeys < ActiveRecord::Migration
  def change
    create_table :api_keys do |t|

    	t.references :application, :null => false
    	t.string "auth_key", :limit => 40, :null => false

      t.timestamps
    end
  end
end
