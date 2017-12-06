require 'rails_helper'

RSpec.describe "staff/travel_claims/show", :type => :view do
  before(:each) do
    @admin_user=FactoryGirl.create(:admin_user)
    sign_in(@admin_user)
    
    ##
    @replacement = FactoryGirl.create(:basic_staff) 
    @hod = FactoryGirl.create(:basic_staff)
    @vehicle = FactoryGirl.create(:vehicle, reg_no: "JJJ1234", staffvehicle: @admin_user.userable)
    @travel_request = FactoryGirl.create(:travel_request, is_submitted: true, destination: 'some destination', depart_at: "2017-09-02 08:38:39", return_at: "2017-09-04 16:38:39" , hod_accept: true, hod_accept_on: Date.today-3.days, applicant: @admin_user.userable, replacement: @replacement, headofdept: @hod, destination: "Putrajaya", dept_car: true, travel_claim_id: nil) 
    @travel_claim_log=FactoryGirl.create(:travel_claim_log, travel_request: @travel_request, travel_on: "2017-09-02", start_at: "2017-09-02 08:38:39", finish_at: "2017-09-02 12:00:00", destination: "From A to B", mileage: 200.0)
    ##
    @travel_claim = FactoryGirl.create(:travel_claim, staff: @admin_user.userable, claim_month: "2017-09-01", is_submitted: nil, submitted_on: nil, is_checked: nil, is_returned: nil, checked_on: nil)
    @travel_request.update_attributes(travel_claim_id: @travel_claim.id)
  end

  it "renders attributes in <dl>" do
    render
    
    assert_select "h1", :text => I18n.t('staff.travel_claim.title')
    
    
    
    #page - buttons / links
    assert_select "a[href=?]", staff_travel_claims_path, {text: "#{I18n.t("helpers.links.back")}" }
    assert_select "a[href=?]", claimprint_staff_travel_claim_path(@travel_claim, format: "pdf")
    assert_select "a[href=?]", edit_staff_travel_claim_path(@travel_claim), {text: "#{I18n.t("helpers.links.edit")}" }
    assert_select "a[href=?]", check_staff_travel_claim_path(@travel_claim), {text: "#{I18n.t("helpers.links.approve")}" }
    assert_select "a[href=?]", approval_staff_travel_claim_path(@travel_claim), {text: "#{I18n.t('staff.travel_claim.log_details')}" }
    assert_select "a[href=?]", staff_travel_claim_path(@travel_claim), {text: I18n.t("helpers.links.destroy")}
   
  end
end