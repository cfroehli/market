# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


u = User.find_by(username: 'toto')
if u.nil?
  u = User.new(username: 'toto', name: 'Toto', address: 'Here', email: 'toto@hazeliris.com', password: 'totopass')
  u.add_role :admin
  u.save
end


u = User.find_by(username: 'titi')
if u.nil?
  u = User.new(username: 'titi', name: 'Titi', address: 'There', email: 'titi@hazeliris.com', password: 'titipass')
  u.save
end

[ 'aoeua', 'ountha', 'sthsa' ].each do |name|
  p = Product.new(name: name,
                  price: Random.rand(100..5000),
                  description: 'aoetnuhaoseu aonse uaonethuaoneuhasoe uasontuh'
                 )
  p.save
end

connection = ActiveRecord::Base.connection()
connection.execute("UPDATE products SET photo = 'image/upload/v1585723801/xie5vjfkd4eocadksusl.jpg'")
