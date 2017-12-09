require 'rails_helper'

RSpec.describe "training/academic_sessions/edit", :type => :view do
  before(:each) do
    @admin_user=FactoryGirl.create(:admin_user)
    sign_in(@admin_user)
    @academic_session = FactoryGirl.create(:academic_session)
  end

  it "renders the edit academic_session form" do
    render

    assert_select "h1", :text => I18n.t('training.academic_session.edit')
    
    #the FORM starts here
    assert_select "form[action=?][method=?]", training_academic_session_path(@academic_session), "post" do
      
      assert_select "input#academic_session_semester[name=?]", "academic_session[semester]"
      assert_select "input#academic_session_total_week[name=?]", "academic_session[total_week]"
      
      # buttons links
      assert_select "a[href=?]", training_academic_session_path(@academic_session), {text: I18n.t("helpers.links.back")}
      assert_select "input.btn.btn-primary[name=?][type=?][value=?]", "commit", "submit", I18n.t('update')
      
    end
    #the FORM ends here
    
  end
end