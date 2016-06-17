puts 'Creating customers'
customer_1 = Customer.create({first_name: 'Angie', last_name: 'Jolie',email: 'customer_1@gmail.com', password: 'testtest1', password_confirmation: 'testtest1', mobile: '9999999999'})
customer_2 = Customer.create ({first_name: 'johnny', last_name: 'depp',email: 'customer_2@gmail.com', password: 'testtest1', password_confirmation: 'testtest1', mobile: '9999999998'})
puts 'creating service providers'
service_provider_1 = ServiceProvider.create({first_name: 'Jaby', last_name: 'Koay',email: 'sp_1@gmail.com', password: 'testtest1', password_confirmation: 'testtest1',
                                            mobile: '9999999997', latitude: 17.509820, longitude: 78.595355, reviews_count: 6, average_review:4.21})
service_provider_2 = ServiceProvider.create({first_name: 'Saint', last_name: 'John',email: 'sp_2@gmail.com', password: 'testtest1', password_confirmation: 'testtest1',
                                            mobile: '9999999996', latitude: 17.513012, longitude: 78.578103, reviews_count: 23, average_review:3.70})

puts 'creating logistics'

Logistic.create({first_name: 'Logistic', last_name: '1', email: 'l1@gmail.com', password: 'testtest1', password_confirmation: 'testtest1', mobile: '9999999995'})
Logistic.create(first_name: 'Logistic', last_name: '2', email:
                             'l2@gmail.com', password: 'testtest1', password_confirmation: 'testtest1',
                             mobile: '9999999994')

puts 'creating service types'
service_type_1 = ServiceType.create(name: 'wash')
service_type_2 = ServiceType.create(name: 'iron')
service_type_3 = ServiceType.create(name: 'wash iron')
service_type_4 = ServiceType.create(name: 'dry cleaning')

puts 'creating items'
item_1 = Item.create(name: 'Jeans')
item_2 = Item.create(name: 'Shirt')
item_3 = Item.create(name: 'Kurta')
item_4 = Item.create(name: 'Track')

puts 'creating item prices'

ItemPrice.create(service_provider_id: service_provider_1.id, item_id: item_1.id,
                 service_type_id: service_type_2.id, price: 11)
ItemPrice.create(service_provider_id: service_provider_1.id, item_id: item_1.id,
                 service_type_id: service_type_3.id, price: 12)
ItemPrice.create(service_provider_id: service_provider_1.id, item_id: item_1.id,
                 service_type_id: service_type_4.id, price: 13)

ItemPrice.create(service_provider_id: service_provider_1.id, item_id: item_2.id,
                 service_type_id: service_type_2.id, price: 15)
ItemPrice.create(service_provider_id: service_provider_1.id, item_id: item_2.id,
                 service_type_id: service_type_3.id, price: 16)
ItemPrice.create(service_provider_id: service_provider_1.id, item_id: item_2.id,
                 service_type_id: service_type_4.id, price: 17)

ItemPrice.create(service_provider_id: service_provider_1.id, item_id: item_3.id,
                 service_type_id: service_type_2.id, price: 19)
ItemPrice.create(service_provider_id: service_provider_1.id, item_id: item_3.id,
                 service_type_id: service_type_3.id, price: 20)
ItemPrice.create(service_provider_id: service_provider_1.id, item_id: item_3.id,
                 service_type_id: service_type_4.id, price: 21)

ItemPrice.create(service_provider_id: service_provider_1.id, item_id: item_4.id,
                 service_type_id: service_type_2.id, price: 23)
ItemPrice.create(service_provider_id: service_provider_1.id, item_id: item_4.id,
                 service_type_id: service_type_3.id, price: 24)
ItemPrice.create(service_provider_id: service_provider_1.id, item_id: item_4.id,
                 service_type_id: service_type_4.id, price: 25)
ItemPrice.create(service_provider_id: service_provider_2.id, item_id: item_1.id,
                 service_type_id: service_type_1.id, price: 26)
ItemPrice.create(service_provider_id: service_provider_2.id, item_id: item_1.id,
                 service_type_id: service_type_2.id, price: 27)
ItemPrice.create(service_provider_id: service_provider_2.id, item_id: item_1.id,
                 service_type_id: service_type_3.id, price: 28)

ItemPrice.create(service_provider_id: service_provider_2.id, item_id: item_2.id,
                 service_type_id: service_type_1.id, price: 30)
ItemPrice.create(service_provider_id: service_provider_2.id, item_id: item_2.id,
                 service_type_id: service_type_2.id, price: 31)
ItemPrice.create(service_provider_id: service_provider_2.id, item_id: item_2.id,
                 service_type_id: service_type_3.id, price: 32)

ItemPrice.create(service_provider_id: service_provider_2.id, item_id: item_3.id,
                 service_type_id: service_type_1.id, price: 34)
ItemPrice.create(service_provider_id: service_provider_2.id, item_id: item_3.id,
                 service_type_id: service_type_2.id, price: 35)
ItemPrice.create(service_provider_id: service_provider_2.id, item_id: item_3.id,
                 service_type_id: service_type_3.id, price: 36)

ItemPrice.create(service_provider_id: service_provider_2.id, item_id: item_4.id,
                 service_type_id: service_type_1.id, price: 38)
ItemPrice.create(service_provider_id: service_provider_2.id, item_id: item_4.id,
                 service_type_id: service_type_2.id, price: 39)
ItemPrice.create(service_provider_id: service_provider_2.id, item_id: item_4.id,
                 service_type_id: service_type_3.id, price: 40)

#
puts 'creating statuses'
Status.create(name: 'created')
Status.create(name: 'picked for service')
Status.create(name: 'started service')
Status.create(name: 'finished service')
Status.create(name: 'picked for delivery')
Status.create(name: 'order completed')

puts 'completed seeding of the data'
