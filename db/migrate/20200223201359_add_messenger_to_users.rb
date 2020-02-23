class AddMessengerToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :messenger, :string
  end
end
