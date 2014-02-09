# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

UserRole.delete_all
ur1 = UserRole.create!(name: 'member')
ur2 = UserRole.create!(name: 'admin')

User.delete_all
u1 = User.new
u1.firstname = 'Peter' 
u1.lastname = 'Emilsson' 
u1.email = 'test@test.com'
u1.password = 'qwerty'
u1.password_confirmation = 'qwerty'
u1.user_role = ur2

u1.save

ApplicationRateLimit.delete_all
ApplicationRateLimit.create!(name: 'bronze', limit: 3000)
ApplicationRateLimit.create!(name: 'silver', limit: 6000)
ApplicationRateLimit.create!(name: 'gold', limit: 10000)