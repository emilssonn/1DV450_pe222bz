class CreateApplicationRateLimits < ActiveRecord::Migration
  def change
    create_table :application_rate_limits do |t|

    	t.string "name", :limit => 30, :null => false
    	t.integer 'limit', :null => false

      t.timestamps
    end
  end
end
