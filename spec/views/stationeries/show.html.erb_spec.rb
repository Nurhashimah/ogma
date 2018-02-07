require 'rails_helper'

RSpec.describe "asset/stationeries/show", :type => :view do
  before(:each) do
    @admin_user=FactoryGirl.create(:admin_user)
    sign_in(@admin_user)
    @stationery=FactoryGirl.create(:stationery)
    @search=Stationery.search(params[:q])
    @stationeries=@search.result.page(params[:page]).per(5)
  end

  it "renders attributes in <dl>" do
    render
    
    assert_select "h1", :text => @stationery.category
      
    assert_select "dl>dt", :text => I18n.t('stationery.code')
    assert_select "dd", :text => @stationery.code
    assert_select "dl>dt", :text => I18n.t('stationery.category')
    assert_select "dd", :text => @stationery.category
    
    #details
    assert_select "dl>dt", :text => I18n.t('stationery.quantity')
#     expect(rendered).to match("249    ")
#        +<dd>
#        +249
#        +&nbsp;
#        +some unit type
#        +</dd>
#     assert_select "dd", :text => "\n#{@stationery.current_quantity}\n&nbsp;\n#{@stationery.unittype}\n".html_safe
    expect(rendered).to match( "\n#{@stationery.current_quantity}\n&nbsp;\n#{@stationery.unittype}\n")
    assert_select "dl>dt", :text => I18n.t('stationery.min')
    assert_select "dd", :text => @stationery.minquantity.to_i
    assert_select "dl>dt", :text => I18n.t('stationery.max')
    assert_select "dd", :text => @stationery.maxquantity.to_i
    
    #additions
#        +<tr>
#        +<td>Lpo No 1</td>
#        +<td>Supplier 1</td>
#        +<td>100</td>
#        +<td>RM 1.00</td>
#        +<td>RM 100.00</td>
#        +<td>09 Dec 2017</td>
#        +</tr>
    assert_select "th", :text => I18n.t('stationery.lpono')
    assert_select "th", :text => I18n.t('stationery.supplier_name')
    assert_select "th", :text => I18n.t('stationery.quantity')
    assert_select "th", :text => I18n.t('stationery.price_per_unit')
    assert_select "th", :text => I18n.t('stationery.total')
    assert_select "th", :text => I18n.t('stationery.received_date')
    assert_select "td", :text => @stationery.stationery_adds.first.lpono
    assert_select "td", :text => @stationery.stationery_adds.first.supplier.name
    assert_select "td", :text => @stationery.stationery_adds.first.quantity
    assert_select "td", :text => currency(@stationery.stationery_adds.first.unitcost)
    assert_select "td", :text => currency(@stationery.stationery_adds.first.line_item_value)
    assert_select "td", :text => @stationery.stationery_adds.first.received.try(:strftime, '%d %b %Y')
    ####
    
    #deductions
    assert_select "th", :text => I18n.t('stationery.issues_by')
    assert_select "th", :text => I18n.t('stationery.received_by')
    assert_select "th", :text => I18n.t('stationery.quantity')
    assert_select "th", :text => I18n.t('stationery.issue_date')
    assert_select "td", :text => @stationery.stationery_uses.first.issuesupply.staff_with_rank
    assert_select "td", :text => @stationery.stationery_uses.first.receivesupply.staff_with_rank
    assert_select "td", :text => @stationery.stationery_uses.first.quantity.to_i.to_s+@stationery.unittype
    assert_select "td", :text => @stationery.stationery_uses.first.issuedate.try(:strftime, "%d %b %Y")
    
    #page - buttons / links
    assert_select "a[href=?]>i.fa.fa-arrow-left", asset_stationeries_path
    assert_select "a[href=?]>i.fa.fa-edit", edit_asset_stationery_path(@stationery)
    assert_select "a[href=?]>i.fa.fa-trash-o.icon-white", asset_stationery_path(@stationery)
   
  end
end

  