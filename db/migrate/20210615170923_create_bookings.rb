class CreateBookings < ActiveRecord::Migration[6.0]
  def change
    create_table :bookings do |t|
      t.string :email
      t.string :payment_token
      t.decimal :amount_charged, precision: 10, scale: 2
      t.boolean :is_save_credit_card
      t.boolean :is_pmd
      t.references :flight, null: false, foreign_key: true

      t.timestamps
    end
  end
end
