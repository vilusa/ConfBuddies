# frozen_string_literal: true

require "rails_helper"

describe "Profile" do
  let(:profile) { create(:profile) }

  include_examples "unauthenticated user does not have access" do
    let(:path) { "/profiles/#{profile.id}".dup }
  end

  context "when user logged in" do
    let(:user) { create :user }

    before(:each) do
      sign_in user
      visit "/profiles/#{profile.id}".dup
    end

    it "shows the profile" do
      expect(page).to have_content "ChaelCodes"
      expect(page).not_to have_link "Edit", href: edit_profile_path(profile)
      expect(page).not_to have_button "Delete"
    end

    context "when user has a profile" do
      let(:profile) { create(:profile, user: user) }

      it "allows user to befriend another" do
        expect(page).to have_button "Request Friend"
        click_button "Request Friend"
        expect(page).to have_content "Friendship was successfully created."
      end
    end

    context "when profile belongs to the user" do
      let(:user) { profile.user }

      it "allows user to edit profile" do
        expect(page).to have_link "Edit", href: edit_profile_path(profile)
        expect(page).to have_button "Delete"
      end
    end

    context "when user is admin" do
      let(:user) { create :user, :admin }

      it "allows user to destroy profile" do
        expect(page).not_to have_link "Edit", href: edit_profile_path(profile)
        expect(page).to have_button "Delete"
      end
    end
  end
end
