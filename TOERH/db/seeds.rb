# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

#U serRoles
UserRole.delete_all

UserRole.create!(name: 'member')
ur2 = UserRole.create!(name: 'admin')

# Users
User.delete_all

u1 = User.new
u1.firstname = 'Peter' 
u1.lastname = 'Emilsson' 
u1.email = 'test@test.com'
u1.password = 'qwerty'
u1.password_confirmation = 'qwerty'
u1.user_role = ur2

u1.save

# ApplicationRareLimits
ApplicationRateLimit.delete_all

ApplicationRateLimit.create!(name: 'bronze', limit: 3000)
ApplicationRateLimit.create!(name: 'silver', limit: 6000)
ar1 = ApplicationRateLimit.create!(name: 'gold', limit: 10000)

# Applications
Application.delete_all

a1 = Application.new
a1.name = 'Test1'
a1.user = u1
a1.application_rate_limit = ar1
a1.api_key = ApiKey.new

a1.save

# ResourceTypes
ResourceType.delete_all
ResourceType.create!(name: 'image')
ResourceType.create!(name: 'video')
ResourceType.create!(name: 'text')

# Licenses
License.delete_all
License.create!(name: 'MIT', url: 'http://opensource.org/licenses/MIT')