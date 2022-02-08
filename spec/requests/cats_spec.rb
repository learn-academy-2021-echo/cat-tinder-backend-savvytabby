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
      it 'does not create a cat without an age' do
        cat_params = {
          cat: {
            name: "Shiba",

            enjoys: "Walking like a doggy",
            image: "https://www.cnet.com/a/img/eWPU7u1-GqGoyEnxge8fLWLyUzg=/2016/11/10/6f83754e-d0b9-4d92-91eb-10773bc2edd0/atchoum2.jpg"
          }
        }
        post '/cats', params: cat_params
        expect(response).to have_http_status(422)
        json = JSON.parse(response.body)
        expect(json['age']).to include "can't be blank"
      end
      it 'does not create a cat without an enjoys' do
        cat_params = {
          cat: {
            name: "Shiba",
            age: 3,

            image: "https://www.cnet.com/a/img/eWPU7u1-GqGoyEnxge8fLWLyUzg=/2016/11/10/6f83754e-d0b9-4d92-91eb-10773bc2edd0/atchoum2.jpg"
          }
        }
        post '/cats', params: cat_params
        expect(response).to have_http_status(422)
        json =JSON.parse(response.body)
        expect(json['enjoys']).to include "can't be blank"
      end
      it 'does not create a cat without an image' do
        cat_params = {
          cat: {
            name: "Shiba",
            age: 3,
            enjoys: "Walking like a doggy"

          }
        }
        post '/cats', params: cat_params
        expect(response).to have_http_status(422)
        json = JSON.parse(response.body)
        p json['image']
        expect(json['image']).to include "can't be blank"
      end
      it 'does not create a cat without enjoys being at least 10 characters long' do
        cat_params = {
          cat: {
            name: "Shiba",
            age: 3,
            enjoys: "Walk",
            image: "https://www.cnet.com/a/img/eWPU7u1-GqGoyEnxge8fLWLyUzg=/2016/11/10/6f83754e-d0b9-4d92-91eb-10773bc2edd0/atchoum2.jpg"
          }
        }
        post '/cats', params: cat_params
        expect(response).to have_http_status(422)
        json = JSON.parse(response.body)
        expect(json['enjoys']).to include "is too short (minimum is 10 characters)"
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
           updated_cat = Cat.find(cat.id)
           cat = Cat.first
           # Assure that we get a success back
           expect(response).to have_http_status(200)
           # Assure that the created cat has the correct attributes
           expect(cat.name).to eq 'Geico'
           expect(cat.age).to eq (100)
           expect(cat.enjoys).to eq ("Sell ice cream in Walmart")
           expect(cat.image).to eq ("https://www.cnet.com/a/img/eWPU7u1-GqGoyEnxge8fLWLyUzg=/2016/11/10/6f83754e-d0b9-4d92-91eb-10773bc2edd0/atchoum2.jpg")
       end
         it "doesn't update a cat without a name" do
           cat_params = {
             cat: {
               name: "Geico",
               age: 12,
               enjoys: "Sell insurance on TV",
               image: "https://www.cnet.com/a/img/eWPU7u1-GqGoyEnxge8fLWLyUzg=/2016/11/10/6f83754e-d0b9-4d92-91eb-10773bc2edd0/atchoum2.jpg"
             }
           }
           post '/cats', params: cat_params
           cat = Cat.first
           updated_cat_params = {
             cat: {
               name: nil,
               age: 100,
               enjoys: "Sell ice cream in Walmart",
               image: "https://www.cnet.com/a/img/eWPU7u1-GqGoyEnxge8fLWLyUzg=/2016/11/10/6f83754e-d0b9-4d92-91eb-10773bc2edd0/atchoum2.jpg"
             }
           }
           patch "/cats/#{cat.id}", params: updated_cat_params
           #update the cat object again (reset variable)
           updated_cat = Cat.find(cat.id)
           cat = Cat.first
           # Assure that we get a success back
           expect(response).to have_http_status(422)
           json = JSON.parse(response.body)
           expect(json['name']).to include "can't be blank"
         end
         it 'doesnt update a cat without an age' do
            cat_params = {
              cat: {
                name: "Geico",
                age: 12,
                enjoys: "Sell insurance on TV",
                image: "https://www.cnet.com/a/img/eWPU7u1-GqGoyEnxge8fLWLyUzg=/2016/11/10/6f83754e-d0b9-4d92-91eb-10773bc2edd0/atchoum2.jpg"
              }
            }
            post '/cats', params: cat_params
            cat = Cat.first
            updated_cat_params = {
              cat: {
                name: "Geico",
                age: nil,
                enjoys: "Sell insurance on TV",
                image: "https://www.cnet.com/a/img/eWPU7u1-GqGoyEnxge8fLWLyUzg=/2016/11/10/6f83754e-d0b9-4d92-91eb-10773bc2edd0/atchoum2.jpg"
              }
            }
            patch "/cats/#{cat.id}", params: updated_cat_params
            updated_cat = Cat.find(cat.id)
            expect(response).to have_http_status(422)
            json = JSON.parse(response.body)
            expect(json['age']).to include "can't be blank"
          end
          it 'doesnt update a cat without an enjoys' do
            cat_params = {
              cat: {
                name: "Geico",
                age: 100,
                enjoys: "Sell ice cream in Walmart",
                image: "https://www.cnet.com/a/img/eWPU7u1-GqGoyEnxge8fLWLyUzg=/2016/11/10/6f83754e-d0b9-4d92-91eb-10773bc2edd0/atchoum2.jpg"
              }
            }
            post '/cats', params: cat_params
            cat = Cat.first
            updated_cat_params = {
              cat: {
                name: "Geico",
                age: 100,
                enjoys: nil,
                image: "https://www.cnet.com/a/img/eWPU7u1-GqGoyEnxge8fLWLyUzg=/2016/11/10/6f83754e-d0b9-4d92-91eb-10773bc2edd0/atchoum2.jpg"
              }
            }
            patch "/cats/#{cat.id}", params: updated_cat_params
            updated_cat = Cat.find(cat.id)
            expect(response).to have_http_status(422)
            json = JSON.parse(response.body)
            expect(json['enjoys']).to include "can't be blank"
          end
          it 'doesnt update a cat without an image' do
            cat_params = {
              cat: {
                name: "Geico",
                age: 100,
                enjoys: "Sell ice cream in Walmart",
                image: "https://www.cnet.com/a/img/eWPU7u1-GqGoyEnxge8fLWLyUzg=/2016/11/10/6f83754e-d0b9-4d92-91eb-10773bc2edd0/atchoum2.jpg"
              }
            }
            post '/cats', params: cat_params
            cat = Cat.first
            updated_cat_params = {
              cat: {
                name: "Geico",
                age: 100,
                enjoys: "Sell ice cream in Walmart",
                image: nil
              }
            }
            patch "/cats/#{cat.id}", params: updated_cat_params
            updated_cat = Cat.find(cat.id)
            expect(response).to have_http_status(422)
            json = JSON.parse(response.body)
            expect(json['image']).to include "can't be blank"
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
