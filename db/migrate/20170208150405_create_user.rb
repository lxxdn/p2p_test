class CreateUser < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :password_digest
      t.string :access_token, index:true
    end
  end
end
