class DoorkeeperApplicationColumns < ActiveRecord::Migration
  def change
  	add_column :oauth_applications, :application_rate_limit_id, :integer, :null => false, :default => 1
  	add_column :oauth_applications, :active, :boolean, :null => false, :default => true
  end
end
