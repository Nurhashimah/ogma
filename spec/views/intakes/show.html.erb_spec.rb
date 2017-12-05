require 'rails_helper'

RSpec.describe "training/intakes/show", :type => :view do
  before(:each) do
    @college=FactoryGirl.create(:college)
    @admin_user=FactoryGirl.create(:admin_user, college_id: @college.id)
    sign_in(@admin_user)
    @intake = FactoryGirl.create(:intake, is_active: true) 
  end

  it "renders attributes in <dl>" do
    render
    
    assert_select "h1", :text => I18n.t('training.intake.title')
      
    assert_select "dl>dt", :text => I18n.t('training.intake.programme_id')
    assert_select "dd", :text => @intake.programme.programme_list
    assert_select "dl>dt", :text => "Siri"
    assert_select "dd", :text => @intake.name
    assert_select "dl>dt", :text => I18n.t('training.intake.register_on')
    assert_select "dd", :text => @intake.register_on.try(:strftime, "%d %b %Y")
    assert_select "dl>dt", :text => I18n.t('training.intake.is_active')
    assert_select "dd", :text => I18n.t('training.intake.active')
    assert_select "dl>dt", :text => I18n.t('training.intake.coordinator')
    assert_select "dd", :text => @intake.coordinator.try(:name)
    assert_select "dl>dt", :text => I18n.t('training.intake.total_division')
    assert_select "dd", :text => @intake.description
    assert_select "dl>dt", :text => I18n.t('training.intake.division_name')
    
#     TODO - below
#     assert_select "dd", :text => "(1) Bendahara - 32 person (2) Temengong - 32 person (3) Laksamana - 32 person (4) Panglima - 32 person"
   
    #page - buttons / links
    assert_select "a[href=?]", training_intakes_path, {text: "#{I18n.t("helpers.links.back")}" }
    assert_select "a[href=?]", edit_training_intake_path(@intake), {text: I18n.t("helpers.links.edit")}
    assert_select "a[href=?]", training_intake_path(@intake), {text: I18n.t("helpers.links.destroy")}
   
  end
end
  