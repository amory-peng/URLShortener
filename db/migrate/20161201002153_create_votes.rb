class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|

      t.integer :user_id, null: false
      t.integer :url_id, null: false
      t.integer :vote_value, null: false

      t.timestamps null: false
    end

    add_index :votes, :user_id
    add_index :votes, :url_id
  end
end
