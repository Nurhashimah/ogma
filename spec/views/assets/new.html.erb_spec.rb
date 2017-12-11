require 'rails_helper'

RSpec.describe "asset/assets/new", :type => :view do
  before(:each) do
    @admin_user=FactoryGirl.create(:admin_user)
    sign_in(@admin_user)
    @asset = FactoryGirl.build(:fixed_asset)
  end

  it "renders the new asset form" do
    render

    assert_select "h1", :text => I18n.t('asset.new')
    
    #the FORM starts here
    assert_select "form[action=?][method=?]", asset_assets_path, "post" do
      
      assert_select "select#asset_assettype[name=?]", "asset[assettype]"
      assert_select "select#asset_receiveddate_1i[name=?]", "asset[receiveddate(1i)]"
      assert_select "select#asset_category_id[name=?]", "asset[category_id]"
      assert_select "input#asset_cardno[name=?]", "asset[cardno]"
      assert_select "input#asset_cardno2[name=?]", "asset[cardno2]"
      assert_select "input#asset_quantity[name=?]", "asset[quantity]"
      
      # buttons links
      assert_select "a[href=?]", asset_assets_path, {text: I18n.t("helpers.links.back")}      
      assert_select "input.btn.btn-primary[name=?][type=?][value=?]", "commit", "submit", I18n.t('create')
      
    end
    #the FORM ends here
    
  end
end