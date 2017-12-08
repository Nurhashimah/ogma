require 'rails_helper'

RSpec.describe "staff_training/ptdos/edit", :type => :view do
  before(:each) do
    @admin_user=FactoryGirl.create(:admin_user)
    sign_in(@admin_user)
    @ptdo = FactoryGirl.create(:ptdo, applicant: @admin_user.userable, final_approve: true, trainee_report: "This is my final report")
  end

  it "renders the edit ptdo form" do
    render

    assert_select "h1", :text => I18n.t('staff.training.application_status.edit_staff_training')
    
    #the FORM starts here
    assert_select "form[action=?][method=?]", staff_training_ptdo_path(@ptdo), "post" do
      
      assert_select "textarea#ptdo_trainee_report[name=?]", "ptdo[trainee_report]"
      
      # buttons links
      assert_select "a[href=?]", staff_training_ptdos_path, {text: I18n.t("helpers.links.back")}
#       also works
#       assert_select "a.btn.btn-default>i.fa.fa-arrow-left"
      
      assert_select "input.btn.btn-primary[name=?][type=?][value=?]", "commit", "submit", I18n.t('update')
      
    end
    #the FORM ends here
    
  end
end