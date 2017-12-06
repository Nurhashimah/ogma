require 'rails_helper'

RSpec.describe "staff/travel_claims/index", :type => :view do
  before(:each) do
    @admin_user=FactoryGirl.create(:admin_user)
    sign_in(@admin_user)
    @travel_claim1 = FactoryGirl.create(:travel_claim, staff: @admin_user.userable, claim_month: "2017-09-01")
    @travel_claim2 = FactoryGirl.create(:travel_claim, staff: @admin_user.userable, claim_month: "2017-10-01")
    @search = TravelClaim.search(params[:q])
    @travel_claims = @search.result.order(staff_id: :asc, claim_month: :asc)
  end

  it "renders a list of travel_claims" do
    render
        
    assert_select "h1", :text => I18n.t('staff.travel_claim.title')
    assert_select "a[href=?]", new_staff_travel_claim_path, :text => I18n.t("actions.new")
    assert_select "a", :text => I18n.t('actions.search')
    assert_select "a[href=?]", travelclaim_list_staff_travel_claims_path(params.merge(format: 'pdf' )), :text => I18n.t('actions.print'), :count => 1
                                  
    assert_select "tr>th>a", :text => I18n.t('staff.travel_claim.month_year').gsub("&", "&amp;")
    assert_select "th>a", :text => I18n.t('staff.travel_claim.name')
    assert_select "th>a", :text => I18n.t('staff.travel_claim.total')
    assert_select "th", :text => "Status"
    
    assert_select "td>a[href=?]", staff_travel_claim_path(@travel_claim1), :text => @travel_claim1.claim_month.try(:strftime, '%B %Y')
    assert_select "td", :text => @travel_claim1.staff.staff_with_rank.strip
    assert_select "td", :text => ringgols(@travel_claim1.total_claims)
    assert_select "td", :text => @travel_claim1.my_claim_status(@admin_user).titleize

  end
end