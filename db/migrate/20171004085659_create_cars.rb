class CreateCars < ActiveRecord::Migration[5.0]
  def change
    create_table :cars do |t|
      t.string :registration_number, unique: true
      t.string :status, default: 'available'
      t.string :model
      t.string :manufacturer
      t.float :rate

      t.timestamps
    end
    add_index :cars, :registration_number, unique: true
  end
end