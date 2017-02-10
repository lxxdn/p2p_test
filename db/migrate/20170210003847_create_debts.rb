class CreateDebts < ActiveRecord::Migration[5.0]
  def change
    create_table :debts do |t|
      t.integer :debtee_id
      t.integer :debtor_id
      t.integer :amount
    end

    add_index :debts, [:debtee_id, :debtor_id]
  end
end
