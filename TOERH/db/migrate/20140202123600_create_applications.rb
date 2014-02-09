class CreateApplications < ActiveRecord::Migration
  def change
    create_table :applications do |t|

    	t.references :user, :null => false

    	t.references :application_rate_limit, :null => false, :default => 1

    	t.string "name", :limit => 30, :null => false
    	t.boolean 'active', :null => false, :default => true

      t.timestamps
    end
  end
end
