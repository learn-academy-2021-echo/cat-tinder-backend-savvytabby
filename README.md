##API intro

### Process
```
$ rails new cat-tinder-backend -d postgresql -T
$  cd cat-tinder-backend
$  git remote add origin https://github.com/learn-academy-2021-echo/cat-tinder-backend-savvytabby.git
$ git checkout -b main
$ git add .
$ git commit -m "init commit"
$ git push origin main
$ rails db:create
$ bundle add rspec-rails
$ rails generate rspec:install

```

### Cat Resource
```
$ rails generate resource Cat name:string age:integer enjoys:text image:text
$ rails db:migrate
```
### Initial Check
```
$ rspec spec
```

### IF we want to checkout our current route
```
$ rails routes --expanded
```
### check the table in the rails database console
```
$ rails c
```
### Seeds.rb

```Ruby
cats = [
  {
    name: "Mittens",
    age: 5,
    enjoys: "Sunshine and warm spots",
    image: "https://images.unsplash.com/photo-1543852786-1cf6624b9987?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=687&q=80"
  },
  {
    name: "Raisins",
    age: 4,
    enjoys: "Being queen of the dogs",
    image: "https://images.unsplash.com/photo-1533743983669-94fa5c4338ec?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1092&q=80"
  },
  {
    name: "Toast",
    age: 1,
    enjoys: "Getting all the attention",
    image: "https://images.unsplash.com/photo-1592194996308-7b43878e84a6?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=687&q=80"
  },
  {
    name: "Barbie",
    age: 7,
    enjoys: "BBQ Lamb",
    image: "https://cdna.artstation.com/p/assets/images/images/031/676/102/large/ana-silence-43565431-2067439716641364-1574266016911851520-n.jpg?1604298130"
  },
  {
    name: "Shiba",
    age: 3,
    enjoys: "Walking like a doggy",
    image: "https://www.cnet.com/a/img/eWPU7u1-GqGoyEnxge8fLWLyUzg=/2016/11/10/6f83754e-d0b9-4d92-91eb-10773bc2edd0/atchoum2.jpg"
  },
  {
    name: "Teddy",
    age: 6,
    enjoys: "Always wear a hat",
    image: "https://i.pinimg.com/564x/33/32/6d/33326dcddbf15c56d631e374b62338dc.jpg"
  }
]

cats.each do |values|
  Cat.create values
  p "creating cats #{values}"
end

```
```
$ rails db:seed
$ rails c
$ pp Cat.all
if you want drop the table $ rails db:drop

but if you ran $ rails db:seed  too many times, it will create the table many times, the id of the table will continue adding up
```
## Skip Authenticity Token
### app/controllers/application_controller.rb
```Ruby
class ApplicationController < ActionController::Base
   skip_before_action :verify_authenticity_token
end
```
## Enable CORS
### Adding this line of code to the Gemfile
```Ruby
gem 'rack-cors', :require => 'rack/cors'
```

### Add a file to the config/initializers directory named cors.rb and add the following code to the new file:
### config/initializers/cors.rb
```Ruby

Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins '*'  # <- change this to allow requests from any domain while in development.

    resource '*',
      headers: :any,
      methods: [:get, :post, :put, :patch, :delete, :options, :head]
  end
end
```
### Run the command $ bundle from the command line to update the dependencies.
```
$ bundle
```

### push to github

```
$ git add .
$ git commit -m "Cat resource, seeds, CORS for backend Cat Tinder project"
$ git push origin backend-structure
```
### after I got approved by instructor

```
$ git checkout main
$ git branch -D backend-structure
$ git branch
$ git checkout -b api-endpoints
$ git fetch origin main
$ git pull origin main
$ git branch
$ bundle
$ yarn

```
## Index Route
### spec/requests/cats_spec.rb

We start with the index route. In this endpoint, we want to return all of the cats that the application knows about.

Create a Spec
We're going to practice Test Driven Development, so let's start with a test. We'll add our test to the cats_request_spec.rb file:
```Ruby
require 'rails_helper'

RSpec.describe "Cats", type: :request do
  describe "GET /index" do
      it "gets a list of cats" do
      # create a cat
      Cat.create(
        name: "Shiba",
        age: 3,
        enjoys: "Walking like a doggy",
        image: "https://www.cnet.com/a/img/eWPU7u1-GqGoyEnxge8fLWLyUzg=/2016/11/10/6f83754e-d0b9-4d92-91eb-10773bc2edd0/atchoum2.jpg"
      )
      # make an index request
      get '/cats'
      #parse request data
      cat = JSON.parse(response.body)
      #asserting against the payload --- such as 200 -- particullar response
      expect(response).to have_http_status(200)
      expect(cat.length).to eq 1
      end
  end
end

```
```
$ rspec spec/requests/cats_spec.rb
```
When we run that spec, it fails of course, because we don't have any code in the controller to respond to the request correctly. Yay failure!

### app/controllers/cats_controller.rb

```Ruby
class CatsController < ApplicationController
  def index
    cats = Cat.all
    render json: cats
  end
end
```
test again ---> it passed
```
$ rspec spec/requests/cats_spec.rb
```

## Create
Next we'll tackle the create route. Let's start with adding a new test:

### add some more code in spec/requests/cats_spec.rb
```Ruby
describe "POST /create" do
    it "creates a cat" do
      # The params we are going to send with the request
      cat_params = {
        cat: {
          name: "Shiba",
          age: 3,
          enjoys: "Walking like a doggy",
          image: "https://www.cnet.com/a/img/eWPU7u1-GqGoyEnxge8fLWLyUzg=/2016/11/10/6f83754e-d0b9-4d92-91eb-10773bc2edd0/atchoum2.jpg"
        }
      }
      # Send the request to the server
      post '/cats', params: cat_params
      # Assure that we get a success back
      expect(response).to have_http_status(200)
      # Look up the cat we expect to be created in the db
      cat = Cat.first
      # Assure that the created cat has the correct attributes
      expect(cat.name).to eq 'Shiba' #("Shiba") is working as well
      expect(cat.age).to eq (3)
      expect(cat.enjoys).to eq ("Walking like a doggy")
      expect(cat.image).to eq ("https://www.cnet.com/a/img/eWPU7u1-GqGoyEnxge8fLWLyUzg=/2016/11/10/6f83754e-d0b9-4d92-91eb-10773bc2edd0/atchoum2.jpg")
    end
 end
 ```

### add more code in the app/controllers/cats_controller.rb
```Ruby
def create
  # Create a new cat
  cat = Cat.create(cat_params)
  render json: cat
end

# Handle strong parameters, so we are secure
private
def cat_params
  params.require(:cat).permit(:name, :age, :enjoys, :image)
end
```
### test it --> 2 examples, 0 failures
```
$ rspec spec/requests/cats_spec.rb
```

## Update
Next we'll tackle the update route. Let's start with adding a new test:
### add some more code in spec/requests/cats_spec.rb
```Ruby
describe "PATCH /update" do
    it "updates a cat" do
      # The params we are going to send with the request
      cat_params = {
        cat: {
          name: "Geico",
          age: 12,
          enjoys: "Sell insurance on TV",
          image: "https://www.cnet.com/a/img/eWPU7u1-GqGoyEnxge8fLWLyUzg=/2016/11/10/6f83754e-d0b9-4d92-91eb-10773bc2edd0/atchoum2.jpg"
        }
      }
      # Send the request to the server
      post '/cats', params: cat_params
      # Look up the cat we expect to be created in the db
      cat = Cat.first
      p cat
      updated_cat_params = {
        cat: {
          name: "Geico",
          age: 100,
          enjoys: "Sell ice cream in Walmart",
          image: "https://www.cnet.com/a/img/eWPU7u1-GqGoyEnxge8fLWLyUzg=/2016/11/10/6f83754e-d0b9-4d92-91eb-10773bc2edd0/atchoum2.jpg"
        }
      }
      patch "/cats/#{cat.id}", params: updated_cat_params
      #update the cat object again (reset variable)
      cat = Cat.first
      # Assure that we get a success back
      expect(response).to have_http_status(200)
      # Assure that the created cat has the correct attributes
      expect(cat.name).to eq 'Geico'
      expect(cat.age).to eq (100)
      expect(cat.enjoys).to eq ("Sell ice cream in Walmart")
      expect(cat.image).to eq ("https://www.cnet.com/a/img/eWPU7u1-GqGoyEnxge8fLWLyUzg=/2016/11/10/6f83754e-d0b9-4d92-91eb-10773bc2edd0/atchoum2.jpg")
      end
 end
 ```

### add more code in the app/controllers/cats_controller.rb
```Ruby
def update
  # Create a new cat
  cat = Cat.find(params[:id])
  cat.update(cat_params)
  render json: cat
end
```
### test it --> 3 examples, 0 failures
```
$ rspec spec/requests/cats_spec.rb
```

## Delete
Next we'll tackle the update route. Let's start with adding a new test:
### add some more code in spec/requests/cats_spec.rb
```Ruby
describe "DELETE /destroy" do
it 'deletes a cat' do
   # The params we are going to send with the request
  cat_params = {
    cat: {
      name: "Dogezilla",
      age: 3,
      enjoys: "Destroy everything",
      image: "https://www.cnet.com/a/img/eWPU7u1-GqGoyEnxge8fLWLyUzg=/2016/11/10/6f83754e-d0b9-4d92-91eb-10773bc2edd0/atchoum2.jpg"
    }
  }
  post '/cats', params: cat_params
  cat = Cat.first
  delete "/cats/#{cat.id}"
  # Assure that we get a success back
  expect(response).to have_http_status(200)
  #update the cat object again (reset variable)
  cats = Cat.all
  # test the payload
  expect(cats).to be_empty
end
end
 ```

### add more code in the app/controllers/cats_controller.rb
```Ruby
def destroy
  # Create a new cat
  cat = Cat.find(params[:id])
  cat.destroy
  render json: cat
end
```
### test it --> 4 examples, 0 failures
```
$ rspec spec/requests/cats_spec.rb
```
## Cat Tinder API Validations

```
$  git checkout main
$  git branch -D api-endpoints
$  git checkout api-validations
$  git fetch origin main
$  git pull origin main
$  bundle
$  yarn
```
### Model Specs
We can create a test that will look for an error if a cat is created without any attributes.

#### add some code in spec/models/cat_spec.rb
```Ruby
RSpec.describe Cat, type: :model do
  it "should validate name" do
    cat = Cat.create
    expect(cat.errors[:name]).to_not be_empty
  end
end
```
#### run the test (expecting 1 example, 1 failure)
```
$ rspec spec/models
```

```Ruby
class Cat < ApplicationRecord
  validates :name, presence: true
end
```
#### run the test (expecting 1 example, 0 failure)
```
$ rspec spec/models  
```
### Request Specs

#### add some code in the spec/requests/cats_spec.rb right underneath describe "POST /create" test (without a cat name)
```Ruby
it "doesn't create a cat without a name" do
   cat_params = {
     cat: {
       age: 3,
       enjoys: "Walking like a doggy",
       image: "https://www.cnet.com/a/img/eWPU7u1-GqGoyEnxge8fLWLyUzg=/2016/11/10/6f83754e-d0b9-4d92-91eb-10773bc2edd0/atchoum2.jpg"
     }
   }
   # Send the request to the  server
   post '/cats', params: cat_params
   # expect an error if the cat_params does not have a name
   # expect(response.status).to eq 422
   expect(response).to have_http_status(422)
   # Convert the JSON response into a Ruby Hash
   json = JSON.parse(response.body)
   # Errors are returned as an array because there could be more than one, if there are more than one validation failures on an attribute.
   expect(json['name']).to include "can't be blank"
 end
```
#### change some code in the app/controllers/cats_controller.rb  add some if statement in the create method

```Ruby
def create
  # Create a new cat
  cat = Cat.create(cat_params)
  if cat.valid?
    render json: cat
  else
    render json: cat.errors, status: 422
 end
end
```
#### run the test (expecting 5 example, 0 failure)
```
$ rspec spec/models  
```



# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...
