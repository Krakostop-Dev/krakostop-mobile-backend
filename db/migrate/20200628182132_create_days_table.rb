class CreateDaysTable < ActiveRecord::Migration[6.0]
  def change
    create_table :days do |t|
      t.string :date, null: false
      t.string :name, null: false
    end
  end
end
