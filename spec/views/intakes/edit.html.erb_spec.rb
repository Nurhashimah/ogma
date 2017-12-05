require 'rails_helper'

RSpec.describe "training/intakes/edit", :type => :view do
  before(:each) do
    @college=FactoryGirl.create(:college)
    @admin_user=FactoryGirl.create(:admin_user, college_id: @college.id)
    sign_in(@admin_user)
    @intake = FactoryGirl.create(:intake, is_active: true) 
  end

  it "renders the edit intake form" do
    render

    assert_select "h1", :text => "#{I18n.t('training.intake.edit')}\n#{@intake.programme.programme_list}\n#{@intake.name}".html_safe
    
    #the FORM starts here
    assert_select "form[action=?][method=?]", training_intake_path(@intake), "post" do
      
      assert_select "select#intake_programme_id[name=?]", "intake[programme_id]"
      assert_select "input#intake_name[name=?]", "intake[name]"
      assert_select "input#intake_register_on[name=?]", "intake[register_on]"   
      assert_select "select#intake_staff_id[name=?]", "intake[staff_id]"
      assert_select "input#intake_is_active[name=?]", "intake[is_active]"
      assert_select "input#intake_description[name=?]", "intake[description]"
#       TODO - below
#       assert_select "input#intake_division_0[name][name=?]", "intake[division][0[name]]"
#       assert_select "input#intake_division_1[name][name=?]", "intake[division][1[name]]"
#       assert_select "input#intake_division_2[name][name=?]", "intake[division][2[name]]"
#       assert_select "input#intake_division_3[name][name=?]", "intake[division][3[name]]"
      
      # buttons links
      assert_select "a[href=?]", training_intake_path(@intake), {text: I18n.t("helpers.links.back")}
      assert_select "a[href=?]", training_intake_path(@intake), {text: I18n.t('submit')}
      
    end
    #the FORM ends here
    
  end
end