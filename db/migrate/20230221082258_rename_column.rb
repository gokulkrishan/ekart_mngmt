class RenameColumn < ActiveRecord::Migration[7.0]
  def change
    rename_column :users, :password_reset_token, :token
    rename_column :users, :password_reset_sent_at, :expire_at

  end
end
