require 'rails_helper'

RSpec.describe "asset/assets/edit", :type => :view do
  before(:each) do
    @admin_user=FactoryGirl.create(:admin_user)
    sign_in(@admin_user)
    @staff=FactoryGirl.create(:basic_staff)
    @asset=FactoryGirl.create(:fixed_asset, typename: "My Type A", name: "My Name A", modelname: "My Model A", serialno: "ABC1289", bookable: true, is_maintainable: true, assignedto: @staff, college_id: @staff.college_id, cardno: "1")
    @asset_placement=FactoryGirl.create(:fixed_asset_placement, asset: @asset, staff: @staff)
    @maint=FactoryGirl.create(:maint, asset: @asset)
  end

  it "renders the edit asset form" do
    render

    assert_select "h1", :text => "#{I18n.t('actions.edit')}\n#{@asset.assetcode}"
    
    #the FORM starts here
    assert_select "form[action=?][method=?]", asset_asset_path(@asset), "post" do
      
      expect(rendered).to match("#{I18n.t('asset.assetcode')}")
      expect(rendered).to match("#{@asset.assetcode}")
      
      #status
      assert_select "input#asset_bookable[name=?]", "asset[bookable]"
      assert_select "input#asset_is_maintainable[name=?]", "asset[is_maintainable]"
      assert_select "input#asset_mark_as_lost[name=?]", "asset[mark_as_lost]"
      assert_select "input#asset_is_disposed[name=?]", "asset[is_disposed]"
      
      #details
      assert_select "select#asset_category_id[name=?]", "asset[category_id]"
      assert_select "input#asset_subcategory[name=?]", "asset[subcategory]"
      assert_select "input#asset_typename[name=?]", "asset[typename]"

      #description
      assert_select "input#asset_name[name=?]", "asset[name]"
      assert_select "select#asset_manufacturer_id[name=?]", "asset[manufacturer_id]"
      assert_select "select#asset_country_id[name=?]", "asset[country_id]"
      assert_select "input#asset_modelname[name=?]", "asset[modelname]"
      assert_select "input#asset_serialno[name=?]", "asset[serialno]"
      assert_select "select#asset_location_id[name=?]", "asset[location_id]"
      assert_select "select#asset_assignedto_id[name=?]", "asset[assignedto_id]"
      assert_select "input#asset_status[name=?]", "asset[status]"
      assert_select "input#asset_otherinfo[name=?]", "asset[otherinfo]"
      
      #purchase
      assert_select "input#asset_orderno[name=?]", "asset[orderno]"
      assert_select "input#asset_purchaseprice[name=?]", "asset[purchaseprice]"
      assert_select "input#asset_purchasedate[name=?]", "asset[purchasedate]"
      assert_select "input#asset_receiveddate[name=?]", "asset[receiveddate]"
      assert_select "select#asset_receiver_id[name=?]", "asset[receiver_id]"
      assert_select "select#asset_supplier_id[name=?]", "asset[supplier_id]"
      
      #placement
      assert_select "select#asset_asset_placements_attributes_0_location_id[name=?]", "asset[asset_placements_attributes][0][location_id]"
      assert_select "select#asset_asset_placements_attributes_0_staff_id[name=?]", "asset[asset_placements_attributes][0][staff_id]"
      assert_select "input#asset_asset_placements_attributes_0_reg_on[name=?]", "asset[asset_placements_attributes][0][reg_on]"
      assert_select "input#asset_asset_placements_attributes_0_quantity[name=?]", "asset[asset_placements_attributes][0][quantity]"
      
      #is_maintainable?
      assert_select "input#asset_remark[name=?]", "asset[remark]"
      assert_select "select#asset_maints_attributes_0_maintainer_id[name=?]", "asset[maints_attributes][0][maintainer_id]"
      assert_select "input#asset_maints_attributes_0_workorderno[name=?]", "asset[maints_attributes][0][workorderno]"
      assert_select "input#asset_maints_attributes_0_maintcost[name=?]", "asset[maints_attributes][0][maintcost]"
      assert_select "textarea#asset_maints_attributes_0_details[name=?]", "asset[maints_attributes][0][details]"
      
      # buttons links
      assert_select "a[href=?]", asset_asset_path(@asset), {text: I18n.t("helpers.links.back")}
      assert_select "input.btn.btn-primary[name=?][type=?][value=?]", "commit", "submit", I18n.t('update')
      
    end
    #the FORM ends here
    
  end
end