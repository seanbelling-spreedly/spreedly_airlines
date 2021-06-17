class CreateFlights < ActiveRecord::Migration[6.0]
  def change
    create_table :flights do |t|
      t.string :from_airport_code
      t.string :to_airport_code
      t.decimal :price, precision: 10, scale: 2
      t.datetime :departure_date

      t.timestamps
    end
  end
end
