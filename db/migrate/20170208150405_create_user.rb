class CreateUser < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.integer :money, default: 0
    end
  end
end
