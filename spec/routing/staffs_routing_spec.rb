require "rails_helper"

RSpec.describe Staff::StaffsController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "staff/staffs").to route_to("staff/staffs#index")
    end

    it "routes to #new" do
      expect(:get => "staff/staffs/new").to route_to("staff/staffs#new")
    end

    it "routes to #show" do
      expect(:get => "staff/staffs/1").to route_to("staff/staffs#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "staff/staffs/1/edit").to route_to("staff/staffs#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "staff/staffs").to route_to("staff/staffs#create")
    end

    it "routes to #update" do
      expect(:put => "staff/staffs/1").to route_to("staff/staffs#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "staff/staffs/1").to route_to("staff/staffs#destroy", :id => "1")
    end

  end
end
