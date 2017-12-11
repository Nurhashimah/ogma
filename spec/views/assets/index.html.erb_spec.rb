require 'rails_helper'

RSpec.describe "asset/assets/index", :type => :view do
  
  before(:each) do
    @admin_user=FactoryGirl.create(:admin_user)
    sign_in(@admin_user)
    @asset1 = FactoryGirl.create(:fixed_asset)
    @asset2 = FactoryGirl.create(:fixed_asset)
    @asset3 = FactoryGirl.create(:inventory)
    @asset4 = FactoryGirl.create(:inventory)
    @search=Asset.search(params[:q])
    @assets = @search.result
    @fa = @assets.where(assettype: 1).sort_by{|x|[x.assetcode.split("/")[3], (x.assetcode.split("/")[4]).to_i, (x.assetcode.split("/")[5]).to_i]}
    @inv = @assets.where(assettype: 2).sort_by{|x|[x.assetcode.split("/")[3], (x.assetcode.split("/")[4]).to_i, (x.assetcode.split("/")[5]).to_i]}
    @fixed_assets = Kaminari.paginate_array(@fa).page(params[:page]||1) 
    @inventories  = Kaminari.paginate_array(@inv).page(params[:page]||1)
  end

  it "renders a list of assets / inventories" do
    render

    assert_select "h1", :text => I18n.t('asset.title')
    
    assert_select "a[href=?]", new_asset_asset_path, :text => I18n.t("actions.new")
    assert_select "a", :text => I18n.t('actions.search')
    assert_select "a[href=?]", "#", :text => I18n.t('actions.print'), :count => 1
    assert_select "a[href=?]", kewpa4_asset_assets_path(params.merge(:format => 'pdf')), :text => "KEW PA4"
    assert_select "a[href=?]", kewpa5_asset_assets_path(params.merge(:format => 'pdf')), :text => "KEW PA5"
    assert_select "a[href=?]", kewpa13_asset_assets_path(params.merge(:format => 'pdf')), :text => "KEW PA13"
    
    #headers
    assert_select "tr>th>a", :text => I18n.t('asset.assetcode')
    assert_select "th>a", :text => I18n.t('asset.name')
    assert_select "th>a", :text => I18n.t('asset.purchasedate')
    assert_select "th", :text => I18n.t('asset.purchaseprice')
    
    #record lines
    #- fixed assets
    assert_select "td>a[href=?]", asset_asset_path(@asset1), :text => @asset1.assetcode, :count => 1
    assert_select "td>a[href=?]", asset_asset_path(@asset2), :text => @asset2.assetcode, :count => 1
    assert_select "td", :text => @asset1.name
    assert_select "td", :text => @asset2.name
    assert_select "td", :text => @asset1.purchasedate.try(:strftime, '%d-%m-%Y')
    assert_select "td", :text => @asset2.purchasedate.try(:strftime, '%d-%m-%Y')
    assert_select "td", :text => currency(@asset1.purchaseprice)
    assert_select "td", :text => currency(@asset2.purchaseprice)
    #- inventories
    assert_select "td>a[href=?]", asset_asset_path(@asset3), :text => @asset3.assetcode, :count => 1
    assert_select "td>a[href=?]", asset_asset_path(@asset4), :text => @asset4.assetcode, :count => 1
    assert_select "td", :text => @asset3.name
    assert_select "td", :text => @asset4.name
    assert_select "td", :text => @asset3.purchasedate.try(:strftime, '%d-%m-%Y')
    assert_select "td", :text => @asset4.purchasedate.try(:strftime, '%d-%m-%Y')
    assert_select "td", :text => currency(@asset3.purchaseprice)
    assert_select "td", :text => currency(@asset4.purchaseprice)
    
  end
end