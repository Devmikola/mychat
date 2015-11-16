class CreateChats < ActiveRecord::Migration
  def change
    create_table :chats do |t|
    	t.integer :creator_id
    	t.string :name
    	t.index :creator_id

    	t.timestamps    	
    end
  end
end
