class RenameLocationReferenceToUser < ActiveRecord::Migration[6.0]
  def change
    rename_column :locations, :user_id, :pair_id
  end
end
