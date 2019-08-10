class CreateTestTables < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.references :group
      t.string  :name
      t.string  :title
      t.integer :age
      t.timestamps
    end

    create_table :groups do |t|
      t.string  :name
      t.string  :title
      t.timestamps
    end
  end
end
