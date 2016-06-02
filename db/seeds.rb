puts 'Creating customers'
customer_1 = Customer.create({first_name: 'Angie', last_name: 'Jolie',email: 'customer_1@gmail.com', password: 'testtest1', password_confirmation: 'testtest1', mobile: '9999999999'})
customer_2 = Customer.create ({first_name: 'johnny', last_name: 'depp',email: 'customer_2@gmail.com', password: 'testtest1', password_confirmation: 'testtest1', mobile: '9999999998'})
puts "creating service providers"
service_provider_1 = ServiceProvider.create({first_name: 'Jaby', last_name: 'Koay',email: 'sp_1@gmail.com', password: 'testtest1', password_confirmation: 'testtest1',
                                            mobile: '9999999997', first_name: 'fnsp_1', last_name: 'lnsp_1',
                                            latitude: 17.509820, longitude: 78.595355, reviews_count: 6, average_review:4.21})
service_provider_2 = ServiceProvider.create({first_name: 'Saint', last_name: 'John',email: 'sp_2@gmail.com', password: 'testtest1', password_confirmation: 'testtest1',
                                            mobile: '9999999996', first_name: 'fnsp_2', last_name: 'lnsp_2',
                                            latitude: 17.513012, longitude: 78.578103, reviews_count: 23, average_review:3.70})

puts "creating service types"
service_type_1 = ServiceType.create(name: "wash")
service_type_2 = ServiceType.create(name: "iron")
service_type_3 = ServiceType.create(name: "wash iron")
service_type_4 = ServiceType.create(name: "dry cleaning")


puts "creating item prices"
item_1 = Item.create(name: "Jeans")
item_2 = Item.create(name: "Shirt")
item_3 = Item.create(name: "Kurta")
item_4 = Item.create(name: "Track")

puts "creating item prices"
# item_price_1 = ItemPrice.create(service_provider_id: service_provider_1.id, item_id: item_1.id, service_type_id: service_type_1.id, price: 10)
item_price_2 = ItemPrice.create(service_provider_id: service_provider_1.id, item_id: item_1.id, service_type_id: service_type_2.id, price: 11)
item_price_3 = ItemPrice.create(service_provider_id: service_provider_1.id, item_id: item_1.id, service_type_id: service_type_3.id, price: 12)
item_price_4 = ItemPrice.create(service_provider_id: service_provider_1.id, item_id: item_1.id, service_type_id: service_type_4.id, price: 13)
# item_price_5 = ItemPrice.create(service_provider_id: service_provider_1.id, item_id: item_2.id, service_type_id: service_type_1.id, price: 14)
item_price_6 = ItemPrice.create(service_provider_id: service_provider_1.id, item_id: item_2.id, service_type_id: service_type_2.id, price: 15)
item_price_7 = ItemPrice.create(service_provider_id: service_provider_1.id, item_id: item_2.id, service_type_id: service_type_3.id, price: 16)
item_price_8 = ItemPrice.create(service_provider_id: service_provider_1.id, item_id: item_2.id, service_type_id: service_type_4.id, price: 17)
# item_price_9 = ItemPrice.create(service_provider_id: service_provider_1.id, item_id: item_3.id, service_type_id: service_type_1.id, price: 18)
item_price_10 = ItemPrice.create(service_provider_id: service_provider_1.id, item_id: item_3.id, service_type_id: service_type_2.id, price: 19)
item_price_11 = ItemPrice.create(service_provider_id: service_provider_1.id, item_id: item_3.id, service_type_id: service_type_3.id, price: 20)
item_price_12 = ItemPrice.create(service_provider_id: service_provider_1.id, item_id: item_3.id, service_type_id: service_type_4.id, price: 21)
# item_price_13 = ItemPrice.create(service_provider_id: service_provider_1.id, item_id: item_4.id, service_type_id: service_type_1.id, price: 22)
item_price_14 = ItemPrice.create(service_provider_id: service_provider_1.id, item_id: item_4.id, service_type_id: service_type_2.id, price: 23)
item_price_15 = ItemPrice.create(service_provider_id: service_provider_1.id, item_id: item_4.id, service_type_id: service_type_3.id, price: 24)
item_price_16 = ItemPrice.create(service_provider_id: service_provider_1.id, item_id: item_4.id, service_type_id: service_type_4.id, price: 25)
item_price_17 = ItemPrice.create(service_provider_id: service_provider_2.id, item_id: item_1.id, service_type_id: service_type_1.id, price: 26)
item_price_18 = ItemPrice.create(service_provider_id: service_provider_2.id, item_id: item_1.id, service_type_id: service_type_2.id, price: 27)
item_price_19 = ItemPrice.create(service_provider_id: service_provider_2.id, item_id: item_1.id, service_type_id: service_type_3.id, price: 28)
# item_price_20 = ItemPrice.create(service_provider_id: service_provider_2.id, item_id: item_1.id, service_type_id: service_type_4.id, price: 29)
item_price_21 = ItemPrice.create(service_provider_id: service_provider_2.id, item_id: item_2.id, service_type_id: service_type_1.id, price: 30)
item_price_22 = ItemPrice.create(service_provider_id: service_provider_2.id, item_id: item_2.id, service_type_id: service_type_2.id, price: 31)
item_price_23 = ItemPrice.create(service_provider_id: service_provider_2.id, item_id: item_2.id, service_type_id: service_type_3.id, price: 32)
# item_price_24 = ItemPrice.create(service_provider_id: service_provider_2.id, item_id: item_2.id, service_type_id: service_type_4.id, price: 33)
item_price_25 = ItemPrice.create(service_provider_id: service_provider_2.id, item_id: item_3.id, service_type_id: service_type_1.id, price: 34)
item_price_26 = ItemPrice.create(service_provider_id: service_provider_2.id, item_id: item_3.id, service_type_id: service_type_2.id, price: 35)
item_price_27 = ItemPrice.create(service_provider_id: service_provider_2.id, item_id: item_3.id, service_type_id: service_type_3.id, price: 36)
# item_price_28 = ItemPrice.create(service_provider_id: service_provider_2.id, item_id: item_3.id, service_type_id: service_type_4.id, price: 37)
item_price_29 = ItemPrice.create(service_provider_id: service_provider_2.id, item_id: item_4.id, service_type_id: service_type_1.id, price: 38)
item_price_30 = ItemPrice.create(service_provider_id: service_provider_2.id, item_id: item_4.id, service_type_id: service_type_2.id, price: 39)
item_price_31 = ItemPrice.create(service_provider_id: service_provider_2.id, item_id: item_4.id, service_type_id: service_type_3.id, price: 40)
# item_price_32 = ItemPrice.create(service_provider_id: service_provider_2.id, item_id: item_4.id, service_type_id: service_type_4.id, price: 41)
#
puts "completed seeding of the data"