require 'rails_helper'

RSpec.describe "training/academic_sessions/show", :type => :view do
  before(:each) do
    @admin_user=FactoryGirl.create(:admin_user)
    sign_in(@admin_user)
    @college=FactoryGirl.create(:college)
    @academic_session = FactoryGirl.create(:academic_session)
  end

  it "renders attributes in <dl>" do
    render
    
    assert_select "h1", :text => I18n.t('training.academic_session.title')
      
    assert_select "dl>dt", :text => I18n.t('training.academic_session.semester')
    assert_select "dd", :text => @academic_session.semester
    assert_select "dl>dt", :text => I18n.t('training.academic_session.total_week')
    assert_select "dd", :text => @academic_session.total_week
    
    #page - buttons / links
    assert_select "a[href=?]", training_academic_sessions_path, {text: "#{I18n.t("helpers.links.back")}" }
    assert_select "a[href=?]", edit_training_academic_session_path(@academic_session), {text: I18n.t("helpers.links.edit")}
    assert_select "a[href=?]", training_academic_session_path(@academic_session), {text: I18n.t("helpers.links.destroy")}
   
  end
end

  