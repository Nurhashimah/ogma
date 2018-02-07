require 'rails_helper'

RSpec.describe "cofiles/show", :type => :view do
  before(:each) do
    @admin_user=FactoryGirl.create(:admin_user)
    sign_in(@admin_user)
    @cofile=FactoryGirl.create(:cofile)
  end

  it "renders attributes in <dl>" do
    render
    
    assert_select "dt", :text => I18n.t('cofile.cofileno')
    assert_select "dd", :text => @cofile.cofileno.strip
    assert_select "dt", :text => I18n.t('cofile.name')
    assert_select "dd", :text => @cofile.name
    assert_select "dt", :text => I18n.t('cofile.location')
    assert_select "dd", :text => @cofile.location
    assert_select "dt", :text => I18n.t('cofile.owner')
    assert_select "dd", :text => @cofile.owner.staff_with_rank.strip
    assert_select "dt", :text => I18n.t('cofile.onloan')
#     assert_select "dd", :text => I18n.t('yes2')
    assert_select "dd>i.fa.fa-tick", 1
    
    assert_select "dt", :text => I18n.t('cofile.onloan_to')
    assert_select "dd", :text => @cofile.borrower.name
    assert_select "dt", :text => I18n.t('cofile.onloandt')
    assert_select "dd", :text => @cofile.onloandt
    assert_select "dt", :text => I18n.t('cofile.onloanxdt')
    assert_select "dd", :text => @cofile.onloanxdt
    
    #page - buttons / links
    assert_select "a[href=?]", cofiles_path, {text: "#{I18n.t("helpers.links.back")}" }
    assert_select "a[href=?]", edit_cofile_path(@cofile), {text: I18n.t("helpers.links.edit")}
    assert_select "a[href=?]", cofile_path(@cofile), {text: I18n.t("helpers.links.destroy")}
  end
end
