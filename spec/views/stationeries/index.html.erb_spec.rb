require 'rails_helper'

RSpec.describe "asset/stationeries/index", :type => :view do
  
  before(:each) do
    @admin_user=FactoryGirl.create(:admin_user)
    sign_in(@admin_user)
    @stationery1=FactoryGirl.create(:stationery)
    @stationery2=FactoryGirl.create(:stationery)
    @additional=FactoryGirl.create(:stationery_add, stationery_id: @stationery1.id, quantity: 150)
    @search=Stationery.search(params[:q])
    @stationeries=@search.result.page(params[:page]).per(5)
  end

  it "renders a list of stationeries" do
    render

    assert_select "h1", :text => I18n.t('stationery.title')
    
    assert_select "a[href=?]", new_asset_stationery_path, :text => I18n.t("actions.new")
    assert_select "a", :text => I18n.t('actions.search')
    assert_select "a[href=?]", kewps13_asset_stationeries_path(:format => 'pdf', :yyear => Date.today.year), :text => "KEW PS13"
    
    #headers
    assert_select "tr>th>a", :text => I18n.t('stationery.code')
    assert_select "th>a", :text => I18n.t('stationery.category')
    assert_select "th>a", :text => I18n.t('stationery.quantity')
    assert_select "th>a", :text => I18n.t('stationery.max')
    assert_select "th>a", :text => I18n.t('stationery.min')
    
    #record lines
    assert_select "td>a[href=?]", asset_stationery_path(@stationery1), :text => @stationery1.code, :count => 1
    assert_select "td>a[href=?]", asset_stationery_path(@stationery2), :text => @stationery2.code, :count => 1
    assert_select "td>a[href=?]", asset_stationery_path(@stationery1), :text => @stationery1.category, :count => 1
    assert_select "td>a[href=?]", asset_stationery_path(@stationery2), :text => @stationery2.category, :count => 1

#     expect(rendered).to match("99    ")
    
#        +<td>
#        +99
#        +&nbsp;
#        +some unit type
#        +</td>

    expect(rendered).to match("\n249\n&nbsp;\n#{@stationery1.unittype}\n")
    expect(rendered).to match("\n#{@stationery2.current_quantity}\n&nbsp;\n#{@stationery2.unittype}\n")
    assert_select "td", :text => @stationery1.maxquantity.to_i
    assert_select "td", :text => @stationery2.maxquantity.to_i
    assert_select "td", :text => @stationery1.minquantity.to_i
    assert_select "td", :text => @stationery2.minquantity.to_i
  end
end