class CreateAnalyses < ActiveRecord::Migration
  def change
    create_table :analyses do |t|
      t.string :year
      t.string :month
      t.timestamps
    end
  end
end
