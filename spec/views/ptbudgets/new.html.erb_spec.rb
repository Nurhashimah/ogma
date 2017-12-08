require 'rails_helper'

RSpec.describe "staff_training/ptbudgets/new", :type => :view do
  before(:each) do
    @admin_user=FactoryGirl.create(:admin_user)
    sign_in(@admin_user)
    @ptbudget = FactoryGirl.build(:ptbudget)
  end

  it "renders new ptbudget form" do
    render

    assert_select "h1", :text => I18n.t('staff.training.budget.new')
    
    #the FORM starts here
    assert_select "form[action=?][method=?]", staff_training_ptbudgets_path, "post" do
      
      assert_select "input#ptbudget_budget[name=?]", "ptbudget[budget]"
      assert_select "input#ptbudget_fiscalstart[name=?]", "ptbudget[fiscalstart]"
     
      # buttons links
      assert_select "a[href=?]", staff_training_ptbudgets_path, {text: I18n.t("helpers.links.back")}
#       also works
#       assert_select "a.btn.btn-default>i.fa.fa-arrow-left"
      
      assert_select "input.btn.btn-primary[name=?][type=?][value=?]", "commit", "submit", I18n.t('create')
      
    end
    #the FORM ends here
    
  end
end