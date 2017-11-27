require "rails_helper"

RSpec.describe Exam::ExamsController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "exam/exams").to route_to("exam/exams#index")
    end

    it "routes to #new" do
      expect(:get => "exam/exams/new").to route_to("exam/exams#new")
    end

    it "routes to #show" do
      expect(:get => "exam/exams/1").to route_to("exam/exams#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "exam/exams/1/edit").to route_to("exam/exams#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "exam/exams").to route_to("exam/exams#create")
    end

    it "routes to #update" do
      expect(:put => "exam/exams/1").to route_to("exam/exams#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "exam/exams/1").to route_to("exam/exams#destroy", :id => "1")
    end

  end
end
