class ChangeByteCapacityOfCardNumber < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :card_number, :integer
    add_column :users, :card_number, :integer, limit: 8
  end
end
