class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
    	t.string :name
    	t.index :name, unique: true

    	t.string :password_digest

  		t.string :remember_token
  		t.index :remember_token
 

    	t.timestamps
    end
  end
end
