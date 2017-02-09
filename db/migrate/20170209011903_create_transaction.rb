class CreateTransaction < ActiveRecord::Migration[5.0]
  def change
    create_table :transactions do |t|
      t.string :type, null: false, index: true
      t.integer :amount, null: false
      t.integer :target_id, null: false
      t.integer :source_id, null: false

      t.timestamps
    end
  end
end
