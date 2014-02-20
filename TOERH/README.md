TOERH
=====

* Create database: rake db:migrate
* Populate database with data: rake db:seed
* Use lvh.me:3000 to access the server, to enable subdomains.

The application uses REDIS for rate limiting. 
The repo includes redis-server.exe for window or download from http://redis.io/download.
Extract the zip file and go to bin/release/ and extract redisbin.zip, it should contain redis-server.exe.

Mac users: install version 2.6.x from http://redis.io/download

### Running

* Start the redis server
* Start the rails server




