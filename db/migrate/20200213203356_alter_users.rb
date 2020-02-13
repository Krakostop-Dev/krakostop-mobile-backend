class AlterUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :phone, :string
    add_column :users, :city, :string
    add_column :users, :verification_code, :string
    add_reference :users, :pair, null: false
  end
end
