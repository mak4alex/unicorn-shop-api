# Unicorn online-shop

## Server Api
Api for super mega unicorn online-shop. 
Server api deploy [here](https://unicorn-shop-api.herokuapp.com/ "Server Api Home").
Docs for server api [here](https://unicorn-shop-api.herokuapp.com/apidocs/ "Server Api Docs")

### Start server

1. Install all dependencies:

        $ bundle install

2. Start MySQL Server, config 'config/database.yml' file 

3. Create database:

        $ rake db:create db:schema:load

4. Start the web server:
      
        $ rails server


## Clients apps

### Admin Client App
[Admin Client Repo](https://github.com/mak4alex/unicorn-admin-client "Admin Client App")

### Customer Client App
[Customer Client Repo](https://github.com/mak4alex/unicorn-shop "Customer Client App")
