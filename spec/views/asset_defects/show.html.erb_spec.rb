require 'rails_helper'

RSpec.describe "asset/asset_defects/show", :type => :view do
  before(:each) do
    @admin_user=FactoryGirl.create(:admin_user)
    sign_in(@admin_user)
    @asset1=FactoryGirl.create(:fixed_asset, typename: "My Type A", name: "My Name A", modelname: "My Model A", serialno: "ABC1289")
    @asset_placement1=FactoryGirl.create(:fixed_asset_placement, asset: @asset1)
    @staff=FactoryGirl.create(:basic_staff_with_rank)
    @defective = FactoryGirl.create(:asset_defect, asset: @asset1, reporter: @staff)
  end

  it "renders attributes in <dl>" do
    render
    
    assert_select "h1", :text => @defective.asset.assetcode
      
    assert_select "dl>dt", :text => I18n.t('asset.assetcode')
    assert_select "dd", :text => @defective.asset.assetcode
    
    #tab_details
    assert_select "dl>dt", :text => I18n.t('asset.category.type_name_model')
    assert_select "dd", :text => "#{@defective.asset.typename} : #{@defective.asset.name} : #{@defective.asset.modelname}" 
    assert_select "dl>dt", :text => I18n.t('asset.serial_no')
    assert_select "dd", :text => @defective.asset.serialno
    assert_select "dl>dt", :text => I18n.t('asset.defect.description')
    assert_select "dd", :text => @defective.description
    assert_select "dl>dt", :text => I18n.t('asset.defect.reported_by')
    assert_select "dd>a[href=?]", staff_info_path(@defective.reporter), :text => @defective.reporter.try(:staff_with_rank)
    
    #tab_process
    assert_select "dl>dt", :text => I18n.t('asset.defect.action_type')
    assert_select "dd", :text => @defective.processtype
    assert_select "dl>dt", :text => I18n.t('asset.defect.recommendation')
    assert_select "dd", :text => @defective.recommendation
    assert_select "dl>dt", :text => I18n.t('asset.defect.processed_by')
    assert_select "dd", :text => "Yes, by  " + @defective.processor.name.to_s + " on  " + (l(@defective.processed_on)).to_s
    
    #tab_decision
    assert_select "dl>dt", :text => I18n.t('asset.defect.approval')
    
    #tab_process & tab_decision
    assert_select "dd", :text => "No", :count => 1
    
    #page - buttons / links
    assert_select "a[href=?]", asset_defects_path, {text: "#{I18n.t("helpers.links.back")}" }
    assert_select "a[href=?]>i.fa.fa-file-pdf-o", kewpa9_asset_defect_path(@defective, format: "pdf")
    assert_select "a[href=?]", edit_asset_defect_path(@defective), {text: I18n.t("helpers.links.edit")}
    assert_select "a[href=?]", process2_asset_defect_path(@defective), {text: I18n.t("helpers.links.process")}
    assert_select "a[href=?]", decision_asset_defect_path(@defective), {text: I18n.t("helpers.links.decision")}
    assert_select "a[href=?]", asset_defect_path(@defective), {text: I18n.t("helpers.links.destroy")}
   
  end
end

  