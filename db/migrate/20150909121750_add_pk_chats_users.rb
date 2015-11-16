class AddPkChatsUsers < ActiveRecord::Migration
  def change
  	add_column :chats_users, :id, :primary_key
  end
end
