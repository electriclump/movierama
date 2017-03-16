require 'rails_helper'
require 'capybara/rails'
require 'support/pages/movie_list'
require 'support/with_user'

RSpec.describe 'active email', type: :feature do

  let(:page) { Pages::MovieList.new }
  context 'without an email' do
    with_logged_in_user

    before { page.open }

    it 'shows a warning' do
      expect(page).to have_content("You don't have an active email")
    end
  end

  context 'with an email' do
    with_logged_in_user(email: 'email@email.com')

    before { page.open }

    it "doesn\'t show a warning" do
      expect(page).to_not have_content("You don't have an active email")
    end
  end
end
