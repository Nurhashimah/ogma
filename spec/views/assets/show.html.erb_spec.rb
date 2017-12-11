require 'rails_helper'

RSpec.describe "asset/assets/show", :type => :view do
  before(:each) do
    @admin_user=FactoryGirl.create(:admin_user)
    sign_in(@admin_user)
    @staff=FactoryGirl.create(:basic_staff)
    @asset=FactoryGirl.create(:fixed_asset, typename: "My Type A", name: "My Name A", modelname: "My Model A", bookable: true, is_maintainable: true, assignedto: @staff)
    @asset_placement=FactoryGirl.create(:fixed_asset_placement, asset: @asset)
    @maint=FactoryGirl.create(:maint, asset: @asset)
  end

  it "renders attributes in <dl> for fixed asset" do
    
    render
    
    assert_select "h1", :text => @asset.assetcode
      
    assert_select "dl>dt", :text => I18n.t('asset.assetcode')
    assert_select "dd", :text => @asset.assetcode
    
    #details
    assert_select "dl>dt", :text => I18n.t('asset.category.title')
    assert_select "dd", :text => @asset.category.try(:description)
    assert_select "dl>dt", :text => I18n.t('asset.subcategory_name')
    assert_select "dd", :text => @asset.subcategory
    assert_select "dl>dt", :text => I18n.t('asset.typename')
    assert_select "dd", :text => @asset.typename
    assert_select "dl>dt", :text => I18n.t('asset.bookable')
    assert_select "dd", :text => I18n.t('asset.bookable_text')
    assert_select "dl>dt", :text => I18n.t('asset.maintainable')
    assert_select "dd", :text => I18n.t('asset.maintainable_text')
    
    #description
    assert_select "dl>dt", :text => I18n.t('asset.name')
    assert_select "dd", :text => @asset.name
    assert_select "dl>dt", :text => I18n.t('asset.manufacturer')
    assert_select "dd", :text => @asset.manufacturer_id
    assert_select "dl>dt", :text => I18n.t('asset.country_id')
    assert_select "dd", :text => @asset.render_origin
    assert_select "dl>dt", :text => I18n.t('asset.model')
    assert_select "dd", :text => @asset.modelname
    assert_select "dl>dt", :text => I18n.t('asset.serial_no')
    assert_select "dd", :text => @asset.serialno
    assert_select "dl>dt", :text => I18n.t('asset.located_at')
    assert_select "dd", :text => @asset.hmlocation.try(:location_list)
    assert_select "dl>dt", :text => I18n.t('asset.assigned_to')
    assert_select "dd", :text => @asset.assignedto.try(:staff_with_rank).strip
    assert_select "dl>dt", :text => I18n.t('asset.status')
    assert_select "dd", :text => @asset.status
    assert_select "dl>dt", :text => I18n.t('asset.other_information')
    assert_select "dd", :text => @asset.otherinfo
    
    #purchase
    assert_select "dl>dt", :text => I18n.t('asset.orderno')
    assert_select "dd", :text => @asset.orderno
    assert_select "dl>dt", :text => I18n.t('asset.purchaseprice')
    assert_select "dd", :text =>     currency(@asset.purchaseprice.to_f)
    assert_select "dl>dt", :text => I18n.t('asset.purchasedate')
    assert_select "dd", :text => @asset.purchasedate.try(:strftime, "%d/%m/%Y")
    assert_select "dl>dt", :text => I18n.t('asset.receiveddate')
    assert_select "dd", :text => @asset.receiveddate.try(:strftime, "%d/%m/%Y")
    assert_select "dl>dt", :text => I18n.t('asset.receivedby')
    assert_select "dd", :text => @asset.receiver.try(:name)
    assert_select "dl>dt", :text => I18n.t('asset.suppliedby')
    assert_select "dd", :text => @asset.supplier_id
    
    #placement
    #-headers
    assert_select "tr>th", :text => I18n.t('asset.located_at')
    assert_select "th", :text => I18n.t('asset.assigned_to')
    assert_select "th", :text => I18n.t('asset.date')
    assert_select "th", :text => I18n.t('asset.quantity')
    #-record lines
    assert_select "tr>td", :text => check_kin {@asset_placement.location.combo_code} 
    assert_select "tr>td", :text => @asset_placement.staff.try(:name)
    assert_select "tr>td", :text => @asset_placement.reg_on.try(:strftime, "%d/%m/%y")
    assert_select "tr>td", :text => 1
    
    #inventory-only
    #assert_select "tr>td>b", :text => @asset.asset_placements.sum(:quantity).to_s+" / "+@asset.quantity.to_s
    
    #maintenance
    #-headers
    assert_select "dt", :text => I18n.t('helpers.label.asset.note')
    assert_select "dd", :text => @asset.remark
    assert_select "tr>th", :text => I18n.t('asset.maint.maintainer_id')
    assert_select "th", :text => I18n.t('asset.maint.workorderno')
    assert_select "th", :text => I18n.t('asset.maint.maintcost')
    assert_select "th", :text => I18n.t('asset.maint.details')
    #-record lines
    assert_select "tr>td", :text => @maint.maintainer.try(:name)
    assert_select "td", :text => @maint.workorderno
    assert_select "td", :text => @maint.maintcost
    assert_select "td", :text => @maint.details
   
    
    #page - buttons / links
    assert_select "a[href=?]>i.fa.fa-arrow-left", asset_assets_path
    assert_select "a[href=?]>i.fa.fa-bug", new_asset_defect_path(:asset_id => @asset)
    assert_select "a[href=?]>i.fa.fa-file-pdf-o", kewpa2_asset_asset_path(@asset, format: "pdf")
    
    assert_select "a[href=?]>i.fa.fa-file-pdf-o", kewpa6_asset_asset_path(@asset, format: "pdf")
    assert_select "a[href=?]>i.fa.fa-file-pdf-o", kewpa14_asset_asset_path(@asset, format: "pdf")
    
    assert_select "a[href=?]>i.fa.fa-edit", edit_asset_asset_path(@asset)
    assert_select "a[href=?]>i.fa.fa-trash-o.icon-white", asset_asset_path(@asset)
   
  end
end

  