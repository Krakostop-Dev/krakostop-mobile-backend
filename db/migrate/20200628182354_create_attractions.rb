class CreateAttractions < ActiveRecord::Migration[6.0]
  def change
    create_table :attractions do |t|
      t.string :name, null: false
      t.string :shortDescription
      t.string :fullDescription
      t.string :place
      t.string :time, null: false
      t.references :day
    end
  end
end
