class CreateUsersTable < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :email, null: false, index: { unique: true }
      t.boolean :verified_login, default: false
      t.timestamps
    end
  end
end
