require 'rails_helper'

RSpec.describe "asset/asset_defects/edit", :type => :view do
  before(:each) do
    @admin_user=FactoryGirl.create(:admin_user)
    sign_in(@admin_user)
    @asset=FactoryGirl.create(:fixed_asset, typename: "My Type A", name: "My Name A", modelname: "My Model A", serialno: "ABC1289")
    @defective = FactoryGirl.create(:asset_defect, asset: @asset, reporter: @admin_user.userable)
  end

  it "renders the edit asset_defect form" do
    render

    assert_select "h1", :text => "#{I18n.t('actions.edit')}\n#{@defective.asset.assetcode}"
    
    #the FORM starts here
    assert_select "form[action=?][method=?]", asset_defect_path(@defective), "post" do
      
      assert_select "dt", :text => I18n.t('asset.assetcode')
      assert_select "dd", :text => @defective.asset.assetcode
      
      assert_select "dt", :text => I18n.t('asset.category.type_name_model')
      assert_select "dd", :text => "#{@defective.asset.typename} : #{@defective.asset.name} : #{@defective.asset.modelname}" 
      
      assert_select "dt", :text => I18n.t('asset.serial_no')
      assert_select "dd", :text => @defective.asset.serialno
    
      assert_select "input#asset_defect_description[name=?]", "asset_defect[description]"
      assert_select "select#asset_defect_reported_by[name=?]", "asset_defect[reported_by]"
      
      # buttons links
      assert_select "a[href=?]", asset_defect_path(@defective), {text: I18n.t("helpers.links.back")}
      assert_select "input.btn.btn-primary[name=?][type=?][value=?]", "commit", "submit", I18n.t('update')
      
    end
    #the FORM ends here
    
  end
end