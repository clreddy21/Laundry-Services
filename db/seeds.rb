puts 'Creating customers'
customer_1 = Customer.create({first_name: 'Angie', last_name: 'Jolie',email: 'customer_1@gmail.com', password: 'testtest1', password_confirmation: 'testtest1', mobile: '9999999999'})
customer_2 = Customer.create ({first_name: 'johnny', last_name: 'depp',email: 'customer_2@gmail.com', password: 'testtest1', password_confirmation: 'testtest1', mobile: '9999999998'})
puts "creating service providers"
service_provider_1 = ServiceProvider.create({first_name: 'Jaby', last_name: 'Koay',email: 'sp_1@gmail.com', password: 'testtest1', password_confirmation: 'testtest1',
                                            mobile: '9999999997', first_name: 'fnsp_1', last_name: 'lnsp_1',
                                            latitude: 17.509820, longitude: 78.595355})
service_provider_2 = ServiceProvider.create({first_name: 'Saint', last_name: 'John',email: 'sp_2@gmail.com', password: 'testtest1', password_confirmation: 'testtest1',
                                            mobile: '9999999996', first_name: 'fnsp_2', last_name: 'lnsp_2',
                                            latitude: 17.513012, longitude: 78.578103})

puts "creating service types"
service_type_1 = ServiceType.create(wash: true, iron: true, wash_iron: false, dry_cleaning: false, user_id: service_provider_1.id)
service_type_2 = ServiceType.create(wash: false, iron: true, wash_iron: true, dry_cleaning: true, user_id: service_provider_2.id)

puts "creating item prices"
item_1 = Item.create(name: "Jeans")
item_2 = Item.create(name: "Shirt")
item_3 = Item.create(name: "Kurta")
item_4 = Item.create(name: "Track")

puts "creating item prices"
item_price_1 = ItemPrice.create(user_id: service_provider_1.id, item_id: item_1.id, wash: 19.00, iron: 2.00, wash_iron: 20.0, dry_cleaning: 1.0)
item_price_2 = ItemPrice.create(user_id: service_provider_1.id, item_id: item_2.id, wash: 9.00, iron: 2.00, wash_iron: 8.0, dry_cleaning: 2.0)
item_price_3 = ItemPrice.create(user_id: service_provider_1.id, item_id: item_3.id, wash: 12.00, iron: 2.00, wash_iron: 10.0, dry_cleaning: 3.0)
item_price_4 = ItemPrice.create(user_id: service_provider_1.id, item_id: item_4.id, wash: 10.00, iron: 2.00, wash_iron: 12.0, dry_cleaning: 4.0)
item_price_5 = ItemPrice.create(user_id: service_provider_2.id, item_id: item_1.id, wash: 4.00, iron: 2.00, wash_iron: 14.0, dry_cleaning: 5.00)
item_price_6 = ItemPrice.create(user_id: service_provider_2.id, item_id: item_3.id, wash: 9.00, iron: 2.00, wash_iron: 16.0, dry_cleaning: 6.0)
item_price_7 = ItemPrice.create(user_id: service_provider_2.id, item_id: item_2.id, wash: 5.00, iron: 2.00, wash_iron: 18.0, dry_cleaning: 7.0)
item_price_8 = ItemPrice.create(user_id: service_provider_2.id, item_id: item_4.id, wash: 7.00, iron: 2.00, wash_iron: 8.0, dry_cleaning: 9.0)

puts "completed seeding of the data"