
shop = Shop.create!(title: 'Unicorn Online Shop', register_number: 'SXU-12345678')

1.upto(50) do |n|
  Distribution.create!(
      {
        title: "Sales distribution ##{n}",
        body: FFaker::Lorem.paragraphs,
        shop: shop
      })
end

1.upto(5) do |n|
  Discount.create!(
      {
          initial_sum: n * 1_000_000,
          percent: n,
          shop: shop
      })
end


Admin.create!(
    {
      email: 'manager@example.com',
      password: 'manager@example.com',
      password_confirmation: 'manager@example.com'
    })

1.upto(200) do |n|
  User.create!(
      {
        email: "user#{n}@example.com",
        password: '11111111',
        password_confirmation: '11111111',
        sex: User::SEXES.sample,
        name: FFaker::NameRU.name,
        phone: FFaker::PhoneNumber.phone_number,
        country: FFaker::AddressRU.country,
        city: FFaker::AddressRU.city,
        address: FFaker::AddressRU.street_address,
        birthday: "#{rand(1965..2000)}-01-01"
      })
end


1.upto(10) do |n|

  parent_category = Category.create!(
      {
          title: "Category ##{n}",
          description: FFaker::Lorem.sentence,
          shop: shop
      })

  1.upto(10) do |k|
    Category.create!(
        {
          title: "SubCategory ##{n}.#{k}",
          description: FFaker::Lorem.sentence,
          parent_category_id: parent_category.id
        })
  end

end

1.upto(10) do |n|
  Stock.create!(
      {
        title: "Holiday stock ##{n}",
        percent: n
      })
end

Category.where.not(parent_category_id: nil).find_each do |category|
  20.times do |n|
    Product.create!(
        {
          title: "Product #{category.id}.#{n}",
          description: FFaker::Lorem.paragraph,
          price: rand.round(4) * 100,
          quantity: rand(50..100),
          published: true,
          category: category,
          weight: rand.round(4) * 1000,
          stock_id: n % 10 == 0 ? Stock.ids.sample : nil
        })
  end
end

user_ids = User.ids
product_ids = Product.ids

1.upto(150) do |n|

  Review.find_or_create_by!( user_id: user_ids.sample,
                             product_id: product_ids.sample ) do |review|
    review.title  = "Review ##{n}"
    review.body   = FFaker::Lorem.paragraph
    review.rating = rand(0..10)
  end

  Favourite.find_or_create_by!( user_id: user_ids.sample,
                                product_id: product_ids.sample )

end


1.upto(1000) do

  user = User.find(user_ids.sample)

  order = Order.new(
      {
        status: Order::STATUSES.sample,
        total: 0.0,
        pay_type: Order::PAY_TYPES.sample,
        user_id: user.id,
        delivery_type: Order::DELIVERY_TYPES.sample,
        comment: FFaker::Lorem.sentence
      })

  rand(1..10).times do
    order.line_items.build(
        {
          product_id: product_ids.sample,
          quantity: rand(1..10)
        })
  end

  order.build_contact(
      {
        email: user.email,
        name: user.name,
        phone: user.phone,
        country: user.country,
        city: user.city,
        address: user.address,
        comment: FFaker::Lorem.sentence
      })

  order.total = order.count_total
  order.save!

end
