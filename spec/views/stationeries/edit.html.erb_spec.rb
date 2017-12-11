require 'rails_helper'

RSpec.describe "asset/stationeries/edit", :type => :view do
  before(:each) do
    @admin_user=FactoryGirl.create(:admin_user)
    sign_in(@admin_user)
    @stationery=FactoryGirl.create(:stationery)
  end

  it "renders the edit stationery form" do
    render
puts "#{@stationery.stationery_adds.count}~~#{@stationery.stationery_uses.count}"
    assert_select "h1", :text => "#{I18n.t('actions.edit')}\n#{@stationery.category}"
    
    #the FORM starts here
    assert_select "form[action=?][method=?]", asset_stationery_path(@stationery), "post" do
      
      #details
      assert_select "input#stationery_code[name=?]", "stationery[code]"
      assert_select "input#stationery_category[name=?]", "stationery[category]"
      assert_select "input#stationery_unittype[name=?]", "stationery[unittype]"
      assert_select "input#stationery_minquantity[name=?]", "stationery[minquantity]"
      assert_select "input#stationery_maxquantity[name=?]", "stationery[maxquantity]"
      
      #addition
      assert_select "input#stationery_stationery_adds_attributes_0_lpono[name=?]", "stationery[stationery_adds_attributes][0][lpono]"
      assert_select "input#stationery_stationery_adds_attributes_0_document[name=?]", "stationery[stationery_adds_attributes][0][document]"
      assert_select "input#stationery_stationery_adds_attributes_0_quantity[name=?]", "stationery[stationery_adds_attributes][0][quantity]"
      assert_select "input#stationery_stationery_adds_attributes_0_unitcost[name=?]", "stationery[stationery_adds_attributes][0][unitcost]"
      assert_select "input#stationery_stationery_adds_attributes_0_received[name=?]", "stationery[stationery_adds_attributes][0][received]"
      
      #deduction
      assert_select "select#stationery_stationery_uses_attributes_0_issuedby[name=?]", "stationery[stationery_uses_attributes][0][issuedby]"
      assert_select "select#stationery_stationery_uses_attributes_0_receivedby[name=?]", "stationery[stationery_uses_attributes][0][receivedby]"
      assert_select "input#stationery_stationery_uses_attributes_0_quantity[name=?]", "stationery[stationery_uses_attributes][0][quantity]"
      assert_select "input#stationery_stationery_uses_attributes_0_issuedate[name=?]", "stationery[stationery_uses_attributes][0][issuedate]"
      
      # buttons links
      assert_select "a[href=?]>i.fa.fa-arrow-left", asset_stationery_path(@stationery)
      assert_select "input.btn.btn-primary[name=?][type=?][value=?]", "commit", "submit", I18n.t('update')
      
    end
    #the FORM ends here
    
  end
end