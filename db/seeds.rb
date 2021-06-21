# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


# clear out anything from before
Booking.delete_all
Flight.delete_all


# seed DB with soem flights
Flight.create!(from_airport_code: 'PDX', to_airport_code: 'RDU', price: '321.12', departure_date: 3.days.from_now.strftime('%Y-%m-%d'))
Flight.create!(from_airport_code: 'PDX', to_airport_code: 'SYD', price: '1234.56', departure_date: 4.days.from_now.strftime('%Y-%m-%d'))
Flight.create!(from_airport_code: 'PDX', to_airport_code: 'LAX', price: '234.56',departure_date: 5.days.from_now.strftime('%Y-%m-%d'))