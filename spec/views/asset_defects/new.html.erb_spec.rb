require 'rails_helper'

RSpec.describe "asset/asset_defects/new", :type => :view do
  before(:each) do
    @admin_user=FactoryGirl.create(:admin_user)
    sign_in(@admin_user)
    @asset_defect = FactoryGirl.build(:asset_defect)
  end

  it "renders the new asset_defect form" do
    render

    assert_select "h1", :text => I18n.t('asset.defect.new')
    
    #the FORM starts here
    assert_select "form[action=?][method=?]", asset_defects_path, "post" do
      
      assert_select "textarea#asset_defect_description[name=?]", "asset_defect[description]"
      
      # buttons links
      assert_select "a[href=?]", asset_assets_path, {text: I18n.t("helpers.links.cancel")}      
      assert_select "input.btn.btn-primary[name=?][type=?][value=?]", "commit", "submit", I18n.t('create')
      
    end
    #the FORM ends here
    
  end
end