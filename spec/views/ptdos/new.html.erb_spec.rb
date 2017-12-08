require 'rails_helper'

RSpec.describe "staff_training/ptdos/new", :type => :view do
  before(:each) do
    @admin_user=FactoryGirl.create(:admin_user)
    sign_in(@admin_user)
    @ptdo = FactoryGirl.build(:ptdo, applicant: @admin_user.userable)
    @staff_list=Staff.valid_staffs.order(rank_id: :asc, name: :asc)
  end

  it "renders new ptdo form" do
    render

    assert_select "h1", :text => I18n.t('staff.training.application_status.title_apply')
    
    #the FORM starts here
    assert_select "form[action=?][method=?]", staff_training_ptdos_path, "post" do
      
      assert_select "input#display[name=?]", "display"
      assert_select "select#ptdo_staff_id[name=?]", "ptdo[staff_id]"
      
      # buttons links
      assert_select "a[href=?]", staff_training_ptschedules_path, {text: I18n.t("helpers.links.back")}
#       also works
#       assert_select "a.btn.btn-default>i.fa.fa-arrow-left"
      
      assert_select "input.btn.btn-primary[name=?][type=?][value=?]", "commit", "submit", I18n.t('staff.training.application_status.apply')
      
    end
    #the FORM ends here
    
  end
end