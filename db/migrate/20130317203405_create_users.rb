class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username
      t.string :email
      t.string :f_name
      t.string :l_name
      t.string :hashed_pass
      t.string :salt
      t.timestamps
    end
  end
end