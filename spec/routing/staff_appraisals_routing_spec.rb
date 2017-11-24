require "rails_helper"

RSpec.describe Staff::StaffAppraisalsController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "staff/staff_appraisals").to route_to("staff/staff_appraisals#index")
    end

    it "routes to #new" do
      expect(:get => "staff/staff_appraisals/new").to route_to("staff/staff_appraisals#new")
    end

    it "routes to #show" do
      expect(:get => "staff/staff_appraisals/1").to route_to("staff/staff_appraisals#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "staff/staff_appraisals/1/edit").to route_to("staff/staff_appraisals#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "staff/staff_appraisals").to route_to("staff/staff_appraisals#create")
    end

    it "routes to #update" do
      expect(:put => "staff/staff_appraisals/1").to route_to("staff/staff_appraisals#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "staff/staff_appraisals/1").to route_to("staff/staff_appraisals#destroy", :id => "1")
    end

  end
end
