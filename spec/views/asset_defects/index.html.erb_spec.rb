require 'rails_helper'

RSpec.describe "asset/asset_defects/index", :type => :view do
  
  before(:each) do
    @admin_user=FactoryGirl.create(:admin_user)
    sign_in(@admin_user)
    @asset1=FactoryGirl.create(:fixed_asset, typename: "My Type A", name: "My Name A", modelname: "My Model A")
    @asset2=FactoryGirl.create(:fixed_asset, typename: "My Type B", name: "My Name B", modelname: "My Model B")
    @asset_placement1=FactoryGirl.create(:fixed_asset_placement, asset: @asset1)
    @asset_placement2=FactoryGirl.create(:fixed_asset_placement, asset: @asset2)
    @asset_defect1 = FactoryGirl.create(:asset_defect, asset: @asset1)
    @asset_defect2 = FactoryGirl.create(:asset_defect, asset: @asset2)
    @search=AssetDefect.search(params[:q])
    @defective=@search.result.page(params[:page]).per(5)
  end

  it "renders a list of asset_defects" do
    render

    assert_select "h1", :text => I18n.t('asset.defect.title')
    
#     assert_select "a[href=?]", new_training_asset_defect_path, :text => I18n.t("actions.new")
    assert_select "a", :text => I18n.t('actions.search')
    assert_select "a[href=?]", defect_list_asset_defects_path(params.merge(format: 'pdf' )), :text => I18n.t('actions.print'), :count => 1
    
    #headers
    assert_select "tr>th>a", :text => I18n.t('asset.assetcode')
    assert_select "th", :text => I18n.t('asset.category.type_name_model')
    assert_select "th>a", :text => I18n.t('asset.serial_no')
    assert_select "th>a", :text => I18n.t('location.title')
    assert_select "th", :text => I18n.t('asset.defect.notes')
    
    #record lines
    assert_select "td>a[href=?]", asset_defect_path(@asset_defect1), :text => @asset_defect1.asset.try(:assetcode), :count => 1
    assert_select "td>a[href=?]", asset_defect_path(@asset_defect2), :text => @asset_defect2.asset.try(:assetcode), :count => 1
    assert_select "td", :text => "#{@asset_defect1.asset.try(:typename)} - #{@asset_defect1.asset.name} - #{@asset_defect1.asset.modelname}"  
    assert_select "td", :text => "#{@asset_defect2.asset.try(:typename)} - #{@asset_defect2.asset.name} - #{@asset_defect2.asset.modelname}"  
    assert_select "td", :text => @asset_defect1.asset.try(:serialno)
    assert_select "td", :text => @asset_defect2.asset.try(:serialno)
    assert_select "td>a[href=?]", campus_location_path(@asset_placement1.location_id), :text => @asset_placement1.try(:location).try(:location_list)
    assert_select "td>a[href=?]", campus_location_path(@asset_placement2.location_id), :text => @asset_placement2.try(:location).try(:location_list)
    
  end
end