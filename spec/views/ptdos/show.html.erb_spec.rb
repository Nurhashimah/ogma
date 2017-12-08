require 'rails_helper'

RSpec.describe "staff_training/ptdos/show", :type => :view do
  before(:each) do
    @admin_user=FactoryGirl.create(:admin_user)
    sign_in(@admin_user)
    @ptdo = FactoryGirl.create(:ptdo, applicant: @admin_user.userable, final_approve: true, trainee_report: nil)
  end

  it "renders attributes in <dl>" do
    render
    
    assert_select "h1", :text => I18n.t('staff.training.application_status.staff_training_details')
      
    assert_select "dl>dt", :text => I18n.t('staff.training.application_status.course_name')
    assert_select "dd", :text => @ptdo.ptschedule.try(:course).try(:name)
    assert_select "dl>dt", :text => I18n.t('staff.training.application_status.date')
    assert_select "dd", :text => @ptdo.ptschedule.start.try(:strftime, '%d-%m-%Y')
    assert_select "dl>dt", :text => I18n.t('staff.training.application_status.staff_name')
    assert_select "dd>a[href=?]", staff_info_path(@ptdo.staff_id), :text => @ptdo.applicant_details.strip
    
    assert_select "dl>dt", :text => I18n.t('staff.training.application_status.single_approve')
    assert_select "dd", :text => I18n.t('staff.training.application_status.approved')
    assert_select "dl>dt", :text => I18n.t('staff.training.application_status.trainee_report')
    assert_select "dd", :text => @ptdo.trainee_report
    
    #page - buttons / links
    assert_select "a[href=?]", staff_training_ptdos_path, {text: "#{I18n.t("helpers.links.back")}" }
#     assert_select "a[href=?]", new_staff_training_ptschedule_path(:ptdo_id => @ptdo)
    assert_select "a[href=?]", edit_staff_training_ptdo_path(@ptdo), {text: I18n.t("helpers.links.edit")}
    assert_select "a[href=?]", staff_training_ptdo_path(@ptdo), {text: I18n.t("helpers.links.destroy")}
   
  end
end

  