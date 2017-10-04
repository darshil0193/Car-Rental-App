class CreateReservations < ActiveRecord::Migration[5.0]
  def change
    create_table :reservations do |t|
      t.datetime :checkout_time
      t.datetime :return_time
      t.boolean :checked_out, default: false
      t.boolean :reserved, default: false
      t.references :user, foreign_key: true
      t.references :car, foreign_key: true

      t.timestamps
    end
  end
end
