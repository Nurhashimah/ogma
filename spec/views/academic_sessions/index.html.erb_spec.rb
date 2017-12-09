require 'rails_helper'

RSpec.describe "training/academic_sessions/index", :type => :view do
  
  before(:each) do
    @admin_user=FactoryGirl.create(:admin_user)
    sign_in(@admin_user)
    @academic_session1 = FactoryGirl.create(:academic_session)
    @academic_session2 = FactoryGirl.create(:academic_session)
    @search=AcademicSession.search(params[:q])
    @academic_sessions=@search.result.page(params[:page]).per(5)
  end

  it "renders a list of academic_sessions" do
    render

    assert_select "h1", :text => I18n.t('training.academic_session.title')
    
    assert_select "a[href=?]", new_training_academic_session_path, :text => I18n.t("actions.new")
    assert_select "a", :text => I18n.t('actions.search')
    assert_select "a[href=?]", academicsession_report_training_academic_sessions_path(params.merge(format: 'pdf' )), :text => I18n.t('actions.print'), :count => 1
    
    #headers
    assert_select "tr>th>a", :text => I18n.t('training.academic_session.semester')
    assert_select "th>a", :text => I18n.t('training.academic_session.total_week')
    
    #record lines
    assert_select "td>a[href=?]", training_academic_session_path(@academic_session1), :text => @academic_session1.semester, :count => 1
    assert_select "td>a[href=?]", training_academic_session_path(@academic_session2), :text => @academic_session2.semester, :count => 1
    assert_select "td", :text => @academic_session1.total_week
    assert_select "td", :text => @academic_session2.total_week

  end
end