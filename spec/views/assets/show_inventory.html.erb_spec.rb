require 'rails_helper'

RSpec.describe "asset/assets/show", :type => :view do
  before(:each) do
    @admin_user=FactoryGirl.create(:admin_user)
    sign_in(@admin_user)
    @staff1=FactoryGirl.create(:basic_staff)
    @staff2=FactoryGirl.create(:basic_staff)
    @asset=FactoryGirl.create(:inventory, typename: "My Type B", name: "My Name B", modelname: "My Model B", assignedto: @staff1, quantity: 3, college_id: @staff1.college_id, cardno: "1", receiveddate: "2018-01-01")
    @room1=FactoryGirl.create(:admin_room)
    @room2=FactoryGirl.create(:admin_room)
    @asset_placement1=FactoryGirl.create(:inventory_placement, asset: @asset, staff: @staff1, quantity: 2, location: @room1)
    @asset_placement2=FactoryGirl.create(:inventory_placement, asset: @asset, staff: @staff2, quantity: 1, location: @room2)
  end

  it "renders attributes in <dl> for inventory" do
    
    render
    
    assert_select "h1", :text => @asset.assetcode
      
    assert_select "dl>dt", :text => I18n.t('asset.assetcode')
    assert_select "dd", :text => @staff1.college.name.split(" ").join("_").downcase+"/I/"+@asset.syear+"/1" #@asset.assetcode
    #details
    assert_select "dl>dt", :text => I18n.t('asset.category.title')
    assert_select "dd", :text => @asset.category.try(:description)
    assert_select "dl>dt", :text => I18n.t('asset.subcategory_name')
    assert_select "dd", :text => @asset.subcategory
    assert_select "dl>dt", :text => I18n.t('asset.typename')
    assert_select "dd", :text => @asset.typename
    assert_select "dl>dt", :text => I18n.t('asset.bookable')
    assert_select "dd", :text => I18n.t('no2')
    assert_select "dl>dt", :text => I18n.t('asset.maintainable')
    assert_select "dd", :text => I18n.t('no2')
    
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
    
# expect(rendered).to match("#{@asset.asset_placements.first.location.name}     ")
#        +<dd>
#        +<div class='col-md-8'>
#        +Room 1 
#        +Room 2 
#        +</div>
#        +</dd>

    #assert_select "dd>div.col-md-8", :text => "#{@asset.asset_placements.first.location.name} \n#{@asset.asset_placements[1].location.name}"

#  +<dd style='padding-left: 70px;'>
#        +Room 1
#        +, 
#        +Room 2

    assert_select "dd", :text => "#{@asset.asset_placements.first.location.name}\n, \n#{@asset.asset_placements[1].location.name}"
    
#       +<dt>Assigned To</dt>
#        +<dd>
#        + Bob2 Uncle - -
#        + Bob2 Uncle,  Bob3 Uncle
#        +</dd>


    assert_select "dl>dt", :text => I18n.t('asset.assigned_to')
    assert_select "dd", :text => "#{@asset.assignedto.try(:staff_with_rank_position_unit).strip}\n#{@asset.asset_placements.first.staff.staff_with_rank}, #{@asset.asset_placements[1].staff.staff_with_rank}" #@asset.assignedto.try(:staff_with_rank).strip
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
    assert_select "dd", :text => @asset.purchasedate.try(:strftime, "%d/%m/%y")
    assert_select "dl>dt", :text => I18n.t('asset.receiveddate')
    assert_select "dd", :text => @asset.receiveddate.try(:strftime, "%d/%m/%y")
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
    assert_select "tr>td", :text => check_kin {@asset_placement1.location.combo_code} 
    assert_select "tr>td", :text => @asset_placement1.staff.try(:name)
    assert_select "tr>td", :text => @asset_placement1.reg_on.try(:strftime, "%d/%m/%y")
    assert_select "tr>td", :text => @asset_placement1.quantity
    
#     inventory-only
    assert_select "tr>td>b", :text => @asset.asset_placements.sum(:quantity).to_s+" / "+@asset.quantity.to_s
    
    #page - buttons / links
    assert_select "a[href=?]>i.fa.fa-arrow-left", asset_assets_path
    assert_select "a[href=?]>i.fa.fa-file-pdf-o", kewpa3_asset_asset_path(@asset, format: "pdf")
    
    assert_select "a[href=?]>i.fa.fa-file-pdf-o", kewpa6_asset_asset_path(@asset, format: "pdf")
    
    assert_select "a[href=?]>i.fa.fa-edit", edit_asset_asset_path(@asset)
    assert_select "a[href=?]>i.fa.fa-trash-o.icon-white", asset_asset_path(@asset)
   
  end
end

  