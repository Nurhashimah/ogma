require 'rails_helper'

RSpec.describe "training/intakes/new", :type => :view do
  before(:each) do
    @college=FactoryGirl.create(:college)
    @admin_user=FactoryGirl.create(:admin_user, college_id: @college.id)
    sign_in(@admin_user)
    @intake = FactoryGirl.build(:intake, is_active: true) 
  end

  it "renders the edit intake form" do
    render

    assert_select "h1", :text => I18n.t('training.intake.new')
    
    #the FORM starts here
    assert_select "form[action=?][method=?]", training_intakes_path, "post" do
      
      assert_select "select#intake_programme_id[name=?]", "intake[programme_id]"
      assert_select "input#intake_name[name=?]", "intake[name]"
      assert_select "input#intake_register_on[name=?]", "intake[register_on]"   
      assert_select "select#intake_staff_id[name=?]", "intake[staff_id]"
      assert_select "input#intake_is_active[name=?]", "intake[is_active]"
      assert_select "input#intake_description[name=?]", "intake[description]"
      
      # buttons links
      assert_select "a[href=?]", training_intakes_path, {text: I18n.t("helpers.links.back")}      
      assert_select "input.btn.btn-primary[name=?][type=?][value=?]", "commit", "submit", I18n.t('training.intake.proceed')
      
    end
    #the FORM ends here
    
  end
end