require 'rails_helper'

RSpec.describe "staff_training/ptschedules/show", :type => :view do
  before(:each) do
    @admin_user=FactoryGirl.create(:admin_user)
    sign_in(@admin_user)
    @ptcourse=FactoryGirl.create(:ptcourse)
    @ptschedule = FactoryGirl.create(:ptschedule, course: @ptcourse, budget_ok: true, final_price: 100.00)
    @ptdo=FactoryGirl.create(:ptdo, applicant: @admin_user.userable, ptschedule: @ptschedule, final_approve: true, trainee_report: "Completed training")
  end

  it "renders attributes in <dl>" do
    render
    
    assert_select "h1", :text => I18n.t('staff.training.schedule.title')
      
    assert_select "dl>dt", :text => I18n.t('staff.training.course.course_type')
    assert_select "dd", :text => (DropDown::STAFF_COURSE_TYPE.find_all{|disp, value| value == @ptcourse.course_type}).map {|disp, value| disp}[0]
    assert_select "dl>dt", :text => I18n.t('staff.training.course.name')
    assert_select "dd", :text => @ptschedule.course.name
    assert_select "dl>dt", :text => I18n.t('staff.training.course.description')
    assert_select "dd", :text => @ptschedule.course.description
    assert_select "dl>dt", :text => I18n.t('staff.training.schedule.start')
    assert_select "dd", :text => "#{@ptschedule.start.try(:strftime, '%d-%m-%Y')}\n#{I18n.t('for')} #{@ptschedule.course.course_total_days}"
    assert_select "dl>dt", :text => I18n.t('staff.training.schedule.location')
    assert_select "dd", :text => @ptschedule.location
    assert_select "dl>dt", :text => I18n.t('staff.training.schedule.min_participants')
    assert_select "dd", :text => @ptschedule.min_participants
    assert_select "dl>dt", :text => I18n.t('staff.training.schedule.max_participants')
    assert_select "dd", :text => @ptschedule.min_participants
    assert_select "dl>dt", :text => I18n.t('staff.training.course.provider')
    assert_select "dd", :text => @ptschedule.course.provider.try(:name) 
    assert_select "dl>dt", :text => I18n.t('staff.training.schedule.payment_method')
    assert_select "dd", :text =>@ptschedule.render_payment
    assert_select "dl>dt", :text => I18n.t('staff.training.schedule.remark')
    assert_select "dd", :text =>@ptschedule.remark
    
    #page - buttons / links
    assert_select "a[href=?]", staff_training_ptschedules_path, {text: "#{I18n.t("helpers.links.back")}" }
    assert_select "a[href=?]", participants_expenses_staff_training_ptschedules_path, {text: (I18n.t('staff.training.schedule.participants_expenses').gsub("&", "&amp;"))}
    assert_select "a[href=?]", edit_staff_training_ptschedule_path(@ptschedule), {text: I18n.t("helpers.links.edit")}
    assert_select "a[href=?]", staff_training_ptschedule_path(@ptschedule), {text: I18n.t("helpers.links.destroy")}
   
  end
end