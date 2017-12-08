require 'rails_helper'

RSpec.describe "staff_training/ptbudgets/show", :type => :view do
  before(:each) do
    @admin_user=FactoryGirl.create(:admin_user)
    sign_in(@admin_user)
    @ptbudget = FactoryGirl.create(:ptbudget, fiscalstart: Date.today.tomorrow)
  end

  it "renders attributes in <dl>" do
    render
    
    assert_select "h1", :text => "#{@ptbudget.fiscalstart.strftime("%d %B %Y")} ~ #{(@ptbudget.fiscalstart + 1.year - 1.day).try(:strftime, "%d %B %Y")}"
      
    assert_select "dl>dt", :text => I18n.t('staff.training.budget.budget')
    assert_select "dd", :text => ringgols(@ptbudget.budget)
    assert_select "dl>dt", :text => I18n.t('staff.training.budget.start')
    assert_select "dd", :text => "#{@ptbudget.fiscalstart.strftime("%d %B %Y")} ~ #{(@ptbudget.fiscalstart + 1.year - 1.day).try(:strftime, "%d %B %Y")}"
    
    #page - buttons / links
    assert_select "a[href=?]", staff_training_ptbudgets_path, {text: "#{I18n.t("helpers.links.back")}" }
    assert_select "a[href=?]", edit_staff_training_ptbudget_path(@ptbudget), {text: I18n.t("helpers.links.edit")}
    assert_select "a[href=?]", staff_training_ptbudget_path(@ptbudget), {text: I18n.t("helpers.links.destroy")}
   
  end
end

  