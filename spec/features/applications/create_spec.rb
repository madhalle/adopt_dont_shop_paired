require 'rails_helper'

RSpec.describe "Application Form" do
  before :each do
    @shelter_1 = Shelter.create(
      name: "Paws For You",
      address: "1234 W Elf Ave",
      city: "Denver",
      state: "Colorado",
      zip: "90210",
    )

    @pet_1 = Pet.create(
      image: 'https://www.petful.com/wp-content/uploads/2014/01/maltese-1.jpg',
      name: "MoMo",
      approximate_age: "4",
      sex: "male",
      shelter_id: @shelter_1.id
    )

    @pet_2 = Pet.create(
      image: 'https://www.petful.com/wp-content/uploads/2014/01/maltese-1.jpg',
      name: "Lucy",
      approximate_age: "4",
      sex: "male",
      shelter_id: @shelter_1.id
    )
  end

  describe "When I want to adopt a pet" do
    it "I can fill out new application form" do
      visit "/pets/#{@pet_1.id}"
      within ".pets-#{@pet_1.id}" do
        click_link "Favorite"
      end

      visit "/pets/#{@pet_2.id}"
      within ".pets-#{@pet_2.id}" do
        click_link "Favorite"
      end

      visit '/favorites'
      click_link "Apply to Adopt"
      expect(current_path).to eq("/applications/new")

      select("#{@pet_1.name}")
      fill_in :name, with: "Jae Park"
      fill_in :address, with: "1234 S Ahgase Way"
      fill_in :city, with: "Arcadia"
      fill_in :state, with: "CA"
      fill_in :zip, with: "91006"
      fill_in :phone_number, with: "626-111-1111"
      fill_in :description, with: "I work from home so I have plenty of time to be with the pet."

      click_on "Submit Application"
      expect(page).to have_content("You have successfully submitted your application")

      visit '/favorites'

      expect(page).to have_content(@pet_2.name)
    end

    it "I will get errors if application form is not completed in its entirety" do
      visit "/pets/#{@pet_1.id}"
      within ".pets-#{@pet_1.id}" do
        click_link "Favorite"
      end

      visit "/pets/#{@pet_2.id}"
      within ".pets-#{@pet_2.id}" do
        click_link "Favorite"
      end

      visit '/favorites'
      click_link "Apply to Adopt"
      expect(current_path).to eq("/applications/new")

      select("#{@pet_1.name}")
      fill_in :name, with: "Jae Park"
      fill_in :address, with: "1234 S Ahgase Way"
      fill_in :city, with: "Arcadia"
      fill_in :zip, with: "91006"
      fill_in :phone_number, with: "626-111-1111"
      fill_in :description, with: "I work from home so I have plenty of time to be with the pet."

      click_on "Submit Application"
      expect(page).to have_content("Application not created: please fill out all indicated fields")
      expect(current_path).to eq("/applications/new")
    end
  end
end
