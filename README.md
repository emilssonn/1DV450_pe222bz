1DV450
======

TOERH
=====

The application uses REDIS for rate limiting. 
The repo includes redis-server.exe for windows or download from http://redis.io/download.
Extract the zip file and go to bin/release/ and extract redisbin.zip, it should contain redis-server.exe.

Mac users: install version 2.6.x from http://redis.io/download

The api is configured to use default host/port

host: localhost
port: 6379

### Init

* TOERH: bundle install
* TOERHClient: bundle install

### Init TOERH

* Create database: rake db:migrate
* Populate database with data: rake db:seed

* Start the redis server
* Start TOERH application: rails s -p 4000

#### Create app

* Go to lvh.me:4000 - sign up - go to devs
* Create application with redirect uri: http://lvh.me:3000/auth/toerh/callback
* Open the file TOERHClient/config/initializers/omniauth.rb
* Fill in the values: ENV["OAUTH_ID"] = 'Your API Key', ENV["OAUTH_SECRET"] = 'Your API secret'

#### Running

* Start the redis server
* Start TOERH application: rails s -p 4000
* Start TOERHClient application: rails s
* Go to lvh.me:3000

#### Admin

Admin can create, update and delete licenses and resource types via the api.

## Bugs

* The next and prev links in the collection responses are not fully functional if the requesting url contains double limit/offset parameters and so on.
* "Bug", if there is more than 30 licenses or resourcetypes they will not show up on the angular app (offset/limit still in use for those)
* "Bug", the SPA app is not optimized for low network use, it will do requests on each page change

## API Changes

* Added doorkeepr to better handle users. Since the api has crud functionality it requires users. It is better to never give out the user passwords to api consumers. Using 3 legged oauth2 the api consumer never get access to the user password.
* Added resources filtering by user (firstname + lastname) to be able to filter by user without having the user_id
* Fixed the free for all api end-points that didnt require the correct user for update/delete.




