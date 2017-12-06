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
    @travel_claim = FactoryGirl.create(:travel_claim, staff: @admin_user.userable, claim_month: "2017-09-01", is_submitted: true, submitted_on: "2017-10-01", is_checked: nil, is_returned: nil, checked_on: nil)
    @travel_request.update_attributes(travel_claim_id: @travel_claim.id)
  end

  it "renders attributes in <dl>" do
    render
    
    assert_select "h1", :text => I18n.t('staff.travel_claim.title')
    
    assert_select "dt", :text => I18n.t('staff.travel_claim.month_year').gsub("&", "&amp;")
    assert_select "dd", :text => l(@travel_claim.claim_month, :format => "%B %Y") 
    assert_select "dt", :text => I18n.t('staff.travel_claim.staff_id')
    assert_select "dd", :text => @travel_claim.staff.staff_with_rank_position.strip
    
    #tab_travel_request_log
    assert_select "dt", :text => I18n.t('staff.travel_request.code')
    assert_select "dd", :text => @travel_request.code
    assert_select "dt", :text => I18n.t('staff.travel_request.application_status')
    assert_select "dd", :text => "#{I18n.t('staff.travel_request.hod_accept')}#{I18n.t( 'staff.travel_request.on2')}#{@travel_request.hod_accept_on.try(:strftime, "%d %b %Y")}#{I18n.t('staff.travel_request.by')}#{@travel_request.headofdept.staff_with_rank}"
    assert_select "dt", :text => I18n.t('staff.travel_request.document_id')
    assert_select "dd", :text => @travel_request.try(:document).try(:doc_details)
    assert_select "dt", :text => I18n.t('staff.travel_request.travel_dates')
    assert_select "dd", :text => @travel_request.travel_dates
    assert_select "dt", :text => I18n.t('staff.travel_request.log_details')
    expect(rendered).to match("#{@travel_claim_log.travel_on.try(:strftime, '%d %b %Y')}")    
    expect(rendered).to match("#{@travel_claim_log.start_at.strftime('%H:%M %p')}")
    expect(rendered).to match("#{@travel_claim_log.finish_at.strftime('%H:%M %p')}")
    expect(rendered).to match("#{@travel_claim_log.destination}")
    expect(rendered).to match("#{@travel_claim_log.mileage}")
    
    # TODO
    #views/show.html.haml -->cont fr line#35 onwards, tab_mileage_table, tab_claims_details & tab_claims_approval
    
    #page - buttons / links
    assert_select "a[href=?]", staff_travel_claims_path, {text: "#{I18n.t("helpers.links.back")}" }
    assert_select "a[href=?]", claimprint_staff_travel_claim_path(@travel_claim, format: "pdf")
    assert_select "a[href=?]", edit_staff_travel_claim_path(@travel_claim), {text: "#{I18n.t("helpers.links.edit")}" } 
#    TODO - below
#     assert_select "a[href=?]", check_staff_travel_claim_path(@travel_claim), {text: "#{I18n.t("helpers.links.finance_check")}" }
#     assert_select "a[href=?]", approval_staff_travel_claim_path(@travel_claim), {text: "#{I18n.t('helpers.links.approve')}" }
    assert_select "a[href=?]", staff_travel_claim_path(@travel_claim), {text: I18n.t("helpers.links.destroy")}
   
  end
end