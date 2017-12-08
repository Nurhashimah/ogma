require 'spec_helper'

describe "Staff Training Cycle " do
  context "Create New Training Budget" do
    let(:ptbudget) { FactoryGirl.create(:ptbudget) }
    before do
      @college=FactoryGirl.create(:college)
      visit staff_training_ptbudgets_path
      click_link('New')
      fill_in 'ptbudget[budget]',         with: 100
    end
    it "should create budget" do
      expect { click_button 'Create' }.to change(Ptbudget, :count).by(1)
    end
  end
  
  context "Delete Training Budget" do
    before do
      @admin_user=FactoryGirl.create(:admin_user)
      sign_in(@admin_user)
      @college=FactoryGirl.create(:college)
      @budget = FactoryGirl.create(:ptbudget,  fiscalstart: Date.today.tomorrow)
      visit staff_training_ptbudget_path(@budget)
    end
    it "should delete budget" do
      expect { click_link I18n.t("helpers.links.destroy") }.to change(Ptbudget, :count).by(-1)
    end
  end
end