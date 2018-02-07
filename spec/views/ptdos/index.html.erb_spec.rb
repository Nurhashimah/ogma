require 'rails_helper'

RSpec.describe "staff_training/ptdos/index", :type => :view do
  
  before(:each) do
    @admin_user=FactoryGirl.create(:admin_user)
    sign_in(@admin_user)
    @ptdo1 = FactoryGirl.create(:ptdo, applicant: @admin_user.userable)
    @ptdo2 = FactoryGirl.create(:ptdo, applicant: @admin_user.userable, final_approve: true, trainee_report: "This is my final report")
    @search=Ptdo.search(params[:q])
    @ptdos=@search.result.page(params[:page]).per(5)
  end

  it "renders a list of ptdos" do
    render

    assert_select "h1", :text => I18n.t('staff.training.application_status.training_request')
    assert_select "a[href=?]", show_total_days_staff_training_ptdos_path(:id=>@admin_user.userable_id)
    assert_select "a", :text => I18n.t('actions.search')
    assert_select "a[href=?]", ptdo_list_staff_training_ptdos_path(params.merge(format: 'pdf' )), :text => I18n.t('actions.print'), :count => 1
    
    #headers
    assert_select "tr>th>a", :text => I18n.t('staff.training.application_status.schedule')
    assert_select "th>a", :text => I18n.t('staff.training.application_status.course_name')
    assert_select "th>a", :text => I18n.t('staff.training.application_status.staff_name')
    assert_select "th", :text => I18n.t('staff.training.application_status.status')
    
    #record lines
    assert_select "td>a[href=?]", staff_training_ptdo_path(@ptdo1), :text => "#{I18n.t( 'staff.training.application_status.group_by')} #{@ptdo1.ptschedule_id.to_s} (#{@ptdo1.ptschedule.start.try(:strftime, '%d %b %y')})", :count => 1
    assert_select "td>a[href=?]", staff_training_ptdo_path(@ptdo2), :text => "#{I18n.t( 'staff.training.application_status.group_by')} #{@ptdo2.ptschedule_id.to_s} (#{@ptdo2.ptschedule.start.try(:strftime, '%d %b %y')})", :count => 1
    assert_select "td", :text => @ptdo1.try(:ptschedule).try(:course).try(:name)
    assert_select "td", :text => @ptdo2.try(:ptschedule).try(:course).try(:name)
    assert_select "td", :text => @ptdo1.applicant_details.strip
    assert_select "td", :text => @ptdo2.applicant_details.strip
    #assert_select "td", :text => I18n.t("staff.training.application_status.auto_app_require_director_app") 
    assert_select "td", :text => I18n.t("staff.training.application_status.auto_app_require_root_app")
    #@ptdo1.apply_dept_status
    assert_select "td", :text => I18n.t("staff.training.application_status.report_submit")
    #@ptdo2.apply_dept_status
  end
end