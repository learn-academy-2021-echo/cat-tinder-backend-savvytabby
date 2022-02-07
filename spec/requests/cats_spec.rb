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
end
