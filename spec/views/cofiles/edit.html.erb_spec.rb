require 'rails_helper'

RSpec.describe "cofiles/edit", :type => :view do
  before(:each) do
    @admin_user=FactoryGirl.create(:admin_user)
    sign_in(@admin_user)
    @cofile=FactoryGirl.create(:cofile)
  end

  it "renders the edit cofile form" do
    render

    assert_select "form[action=?][method=?]", cofile_path(@cofile), "post" do
      assert_select "input#cofile_cofileno[name=?]", "cofile[cofileno]"
      assert_select "input#cofile_name[name=?]", "cofile[name]"
      assert_select "input#cofile_location[name=?]", "cofile[location]"
      assert_select "select#cofile_owner_id[name=?]", "cofile[owner_id]"
      assert_select "input#fileborrow[name=?]", "cofile[onloan]"
      assert_select "select#cofile_staffloan_id[name=?]", "cofile[staffloan_id]"
      assert_select "input#cofile_onloandt[name=?]", "cofile[onloandt]"
      assert_select "input#cofile_onloanxdt[name=?]", "cofile[onloanxdt]"
      
      # buttons links
      assert_select "a[href=?]", cofile_path(@cofile), {text: I18n.t("helpers.links.back")}
      assert_select "input.btn.btn-primary[name=?][type=?][value=?]", "commit", "submit", I18n.t('update')
      
    end
  end
end
