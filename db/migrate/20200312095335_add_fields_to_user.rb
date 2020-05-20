class AddFieldsToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :is_phone_enabled, :boolean, default: true
    add_column :users, :facebook, :string, default: 'facebook.com/zuck'
  end
end
