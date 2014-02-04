class CreateApplications < ActiveRecord::Migration
  def change
    create_table :applications do |t|

    	t.references :user, :null => false

    	t.string "name", :limit => 30, :null => false

      t.timestamps
    end
  end
end
