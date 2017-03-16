require 'rails_helper'
RSpec.feature "My feature" do
  context "when I visit my root path" do
    scenario "I should find hola mundo" do
      visit root_path
        expect(page).to have_content("Hola Mundo")
    end
  end
end 
=begin
feature "root home" do
end
=end

