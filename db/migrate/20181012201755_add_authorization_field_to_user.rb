class AddAuthorizationFieldToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :authorization, :integer, default: 0
  end
end
