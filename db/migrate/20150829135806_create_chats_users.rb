class CreateChatsUsers < ActiveRecord::Migration
  def change
    create_table :chats_users, id: false do |t|
    	t.integer :chat_id
    	t.integer :member_id
    	t.integer :num_unread_msgs
    	t.index [:chat_id, :member_id], unique: true
    end
  end
end
