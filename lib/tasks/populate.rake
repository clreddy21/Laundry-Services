namespace :create_admin do

  task build: :environment do
    puts "Creating Admin ...."

    admin = Admin.new({:first_name => "Ravi", :last_name => "Verma", :email => "admin@laundryservices.com", :is_active => true,
                       :password => "testtest1", :password_confirmation => "testtest1", slug: "ravi_verma"}).save(:validate => false)

    puts "Admin created Successfully.......................!"
  end
end