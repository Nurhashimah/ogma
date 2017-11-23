require "rails_helper"

RSpec.describe Campus::AddressBooksController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "campus/address_books").to route_to("campus/address_books#index")
    end
    
    it "routes to #new" do
      expect(:get => "campus/address_books/new").to route_to("campus/address_books#new")
    end

    it "routes to #edit" do
      expect(:get => "campus/address_books/1/edit").to route_to("campus/address_books#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "campus/address_books").to route_to("campus/address_books#create")
    end

    it "routes to #update" do
      expect(:put => "campus/address_books/1").to route_to("campus/address_books#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "campus/address_books/1").to route_to("campus/address_books#destroy", :id => "1")
    end
    
  end
end