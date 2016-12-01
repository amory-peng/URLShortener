class MakePremium < ActiveRecord::Migration
  def change
    add_column :users, :premium, :boolean
    change_column_default :users, :premium, false
  end
end
