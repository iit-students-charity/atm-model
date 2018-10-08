class AddFieldsToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :card_number, :integer
    add_column :users, :pin, :integer
    add_column :users, :balance, :integer
    add_column :users, :attempts, :integer
  end
end
