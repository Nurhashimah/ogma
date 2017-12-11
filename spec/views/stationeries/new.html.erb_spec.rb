require 'rails_helper'

RSpec.describe "asset/stationeries/new", :type => :view do
  before(:each) do
    @admin_user=FactoryGirl.create(:admin_user)
    sign_in(@admin_user)
    @stationery=FactoryGirl.build(:stationery)
  end

  it "renders the new stationery form" do
    render

    assert_select "h1", :text => I18n.t('stationery.new')
    
    #the FORM starts here
    assert_select "form[action=?][method=?]", asset_stationeries_path, "post" do
      
      assert_select "input#stationery_code[name=?]", "stationery[code]"
      assert_select "input#stationery_category[name=?]", "stationery[category]"
      assert_select "input#stationery_unittype[name=?]", "stationery[unittype]"
      assert_select "input#stationery_minquantity[name=?]", "stationery[minquantity]"
      assert_select "input#stationery_maxquantity[name=?]", "stationery[maxquantity]"
      
      # buttons links
      assert_select "a[href=?]>i.fa.fa-arrow-left", asset_stationeries_path     
      assert_select "input.btn.btn-primary[name=?][type=?][value=?]", "commit", "submit", I18n.t('create')
      
    end
    #the FORM ends here
    
  end
end 
