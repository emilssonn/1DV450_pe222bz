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
u1.firstname = 'Karl' 
u1.lastname = 'Karlsson' 
u1.email = 'karl@test.com'
u1.password = 'qwerty'
u1.password_confirmation = 'qwerty'
u1.user_role = ur2

u1.save

# ApplicationRateLimits
ApplicationRateLimit.delete_all

ApplicationRateLimit.create!(name: 'Bronze', limit: 3000)
ApplicationRateLimit.create!(name: 'Silver', limit: 6000)
ar1 = ApplicationRateLimit.create!(name: 'Gold', limit: 10000)

# Applications
Application.delete_all

a1 = Application.new
a1.name = 'Test application'
a1.user = u1
a1.application_rate_limit = ar1
a1.api_key = ApiKey.new

a1.save

# ResourceTypes
ResourceType.delete_all

ResourceType.create!(name: 'Image')
ResourceType.create!(name: 'Video')
ResourceType.create!(name: 'Text')
restype = ResourceType.create!(name: 'Software')

# Licenses
License.delete_all

l1 = License.create!(name: 'MIT', url: 'http://opensource.org/licenses/MIT', description: 
	'The MIT License (MIT)

	Copyright (c) <year> <copyright holders>

	Permission is hereby granted, free of charge, to any person obtaining a copy
	of this software and associated documentation files (the "Software"), to deal
	in the Software without restriction, including without limitation the rights
	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
	copies of the Software, and to permit persons to whom the Software is
	furnished to do so, subject to the following conditions:

	The above copyright notice and this permission notice shall be included in
	all copies or substantial portions of the Software.

	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
	THE SOFTWARE.
')

# Tags
Tag.delete_all

t1 = Tag.create!(name: "MIT")
t2 = Tag.create!(name: "Free")
t3 = Tag.create!(name: "Software")
t4 = Tag.create!(name: "GitHub")

# Resource
Resource.delete_all

r = Resource.new
r.name = "Doorkeeper"
r.description = "Doorkeeper is an OAuth 2 provider for Rails"
r.url = "https://github.com/applicake/doorkeeper"
r.user = u1
r.license = l1
r.resource_type = restype
r.tags << t2
r.tags << t3
r.tags << t4

r.save!