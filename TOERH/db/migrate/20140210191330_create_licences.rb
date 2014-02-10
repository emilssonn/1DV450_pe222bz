class CreateLicences < ActiveRecord::Migration
  def change
    create_table :licences do |t|

      t.timestamps
    end
  end
end
