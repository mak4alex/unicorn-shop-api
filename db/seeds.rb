# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.create!({ email: 'user@example.com',
               password: 'user@example.com',
               password_confirmation: 'user@example.com' } )


1.upto(10) do |n|
  Category.create!( title: "Category ##{n}",
                    description: FFaker::Lorem.sentence )
end

11.upto(30) do |n|
  Category.create!( title: "Category ##{n}",
                    description: FFaker::Lorem.sentence,
                    parent_category_id: Category.ids.sample )
end


100.times do |n|
  Product.create!( title: "Product ##{n}",
                   description: FFaker::Lorem.sentence,
                   price: rand.round(4) * 100,
                   quantity: rand(1..20),
                   published: n.even?,
                   category_id: Category.ids.sample,
                   weight: 1 )
end
