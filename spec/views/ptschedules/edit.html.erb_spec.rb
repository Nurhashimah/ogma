require 'rails_helper'

RSpec.describe "staff_training/ptschedules/edit", :type => :view do
  before(:each) do
    @admin_user=FactoryGirl.create(:admin_user)
    sign_in(@admin_user)
    @ptcourse=FactoryGirl.create(:ptcourse)
    @ptschedule = FactoryGirl.create(:ptschedule, course: @ptcourse, budget_ok: true, final_price: 100.00)
    @ptdo=FactoryGirl.create(:ptdo, applicant: @admin_user.userable, ptschedule: @ptschedule, final_approve: true, trainee_report: "Completed training")
  end

  it "renders the edit ptschedule form" do
    render

    assert_select "h1", :text => I18n.t('staff.training.schedule.edit')
    
    #the FORM starts here
    assert_select "form[action=?][method=?]", staff_training_ptschedule_path(@ptschedule), "post" do
      
      assert_select "input#ptschedule_start[name=?]", "ptschedule[start]"
      assert_select "input#ptschedule_min_participants[name=?]", "ptschedule[min_participants]"   
      assert_select "input#ptschedule_max_participants[name=?]", "ptschedule[max_participants]"
      assert_select "input#ptschedule_location[name=?]", "ptschedule[location]"
      assert_select "input#ptschedule_final_price[name=?]", "ptschedule[final_price]"
      assert_select "input#ptschedule_budget_ok[name=?]", "ptschedule[budget_ok]"
      assert_select "select#ptschedule_payment[name=?]", "ptschedule[payment]"
      assert_select "textarea#ptschedule_remark[name=?]", "ptschedule[remark]"
      
      # buttons links
      assert_select "a[href=?]", staff_training_ptschedules_path, {text: I18n.t("helpers.links.back")}
#       also works
#       assert_select "a.btn.btn-default>i.fa.fa-arrow-left"
      
      assert_select "input.btn.btn-primary[name=?][type=?][value=?]", "commit", "submit", I18n.t('update')
      
    end
    #the FORM ends here
    
  end
end