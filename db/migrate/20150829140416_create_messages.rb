class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
    	t.integer :chat_id
    	t.integer :creator_id
    	t.string :text, limit: 1000

    	t.index :chat_id
    	t.index :creator_id

    	t.timestamps
    end
  end
end
