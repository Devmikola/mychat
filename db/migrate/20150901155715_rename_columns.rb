class RenameColumns < ActiveRecord::Migration
  def change
  	rename_column :chats_users, :member_id, :user_id
  	rename_column :chats, :creator_id, :user_id
  	rename_column :messages, :creator_id, :user_id
  end
end
