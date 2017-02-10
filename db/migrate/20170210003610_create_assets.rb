class CreateAssets < ActiveRecord::Migration[5.0]
  def change
    create_table :assets do |t|
      t.integer :user_id, index: true
      t.integer :balance, default: 0
      t.integer :amount_of_lend, default: 0
      t.integer :amount_of_borrow, default: 0

      t.timestamp
    end
  end
end
