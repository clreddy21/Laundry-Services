customer_1 = Customer.create({email: 'customer_1@gmail.com', password: 'testtest1', password_confirmation: 'testtest1'})
customer_2 = Customer.create ({email: 'customer_2@gmail.com', password: 'testtest1', password_confirmation: 'testtest1'})
service_provider_1 = ServiceProvider.create({email: 'sp_1@gmail.com', password: 'testtest1', password_confirmation: 'testtest1',
                                            mobile: '9999999999', first_name: 'fnsp_1', last_name: 'lnsp_1',
                                            latitude: '17.509820', longitude: '78.595355'})
service_provider_2 = ServiceProvider.create({email: 'sp_2@gmail.com', password: 'testtest1', password_confirmation: 'testtest1',
                                            mobile: '9999999998', first_name: 'fnsp_2', last_name: 'lnsp_2',
                                            latitude: '17.513012', longitude: '78.578103'})

service_type_1 = ServiceType.create(wash: true, iron: true, wash_iron: false, dry_cleaning: false, service_provider_id: service_provider_1.id)
service_type_2 = ServiceType.create(wash: false, iron: true, wash_iron: true, dry_cleaning: true, service_provider_id: service_provider_2.id)
