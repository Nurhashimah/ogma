require 'rails_helper'

RSpec.describe "staff_training/ptbudgets/edit", :type => :view do
  before(:each) do
    @admin_user=FactoryGirl.create(:admin_user)
    sign_in(@admin_user)
    @ptbudget = FactoryGirl.create(:ptbudget)
  end

  it "renders the edit ptbudget form" do
    render

    assert_select "h1", :text => I18n.t('ptbudgets.edit')
    
    #the FORM starts here
    assert_select "form[action=?][method=?]", staff_training_ptbudget_path(@ptbudget), "post" do
      
      assert_select "input#ptbudget_budget[name=?]", "ptbudget[budget]"
      assert_select "input#ptbudget_fiscalstart[name=?]", "ptbudget[fiscalstart]"
      
      # buttons links
      assert_select "a[href=?]", staff_training_ptbudgets_path, {text: I18n.t("helpers.links.back")}
#       also works
#       assert_select "a.btn.btn-default>i.fa.fa-arrow-left"
      
      assert_select "input.btn.btn-primary[name=?][type=?][value=?]", "commit", "submit", I18n.t('update')
      
    end
    #the FORM ends here
    
  end
end