require 'rails_helper'

RSpec.describe "staff/travel_claims/show", :type => :view do
  before(:each) do
    @admin_user=FactoryGirl.create(:admin_user)
    sign_in(@admin_user)
    
    ##
    @replacement = FactoryGirl.create(:basic_staff) 
    @hod = FactoryGirl.create(:basic_staff)
    @vehicle = FactoryGirl.create(:vehicle, reg_no: "JJJ1234", staffvehicle: @admin_user.userable)
    @travel_request = FactoryGirl.create(:travel_request, is_submitted: true, destination: 'some destination', depart_at: "2017-09-02 08:38:39", return_at: "2017-09-04 16:38:39" , hod_accept: true, hod_accept_on: Date.today-3.days, applicant: @admin_user.userable, replacement: @replacement, headofdept: @hod, destination: "Putrajaya", dept_car: true, taxi: true, travel_claim_id: nil) 
    @travel_claim_log=FactoryGirl.create(:travel_claim_log, travel_request: @travel_request, travel_on: "2017-09-02", start_at: "2017-09-02 08:38:39", finish_at: "2017-09-02 12:00:00", destination: "From A to B", mileage: 200.0)
    ##
    @travel_claim = FactoryGirl.create(:travel_claim, staff: @admin_user.userable, claim_month: "2017-09-01", is_submitted: true, submitted_on: "2017-10-01", is_checked: nil, is_returned: nil, checked_on: nil)
    @travel_claim_receipt=FactoryGirl.create(:travel_claim_receipt, travel_claim: @travel_claim, expenditure_type: 11, spent_on: "2017-09-03", amount: 15.00, quantity: 1.0)
    @travel_request.update_attributes(travel_claim_id: @travel_claim.id)
    @is_admin=true #required for finance_check & approve buttons
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
    
    #travel_request_log & tab_mileage_table, tab_claims_details(2)
    assert_select "b", :text =>  I18n.t('staff.travel_request.total'), :count => 4
    
    #travel_request_log
    expect(rendered).to match("#{@travel_claim.total_mileage}")
    expect(rendered).to match("#{@travel_claim.total_km_money}")
    
    #tab_mileage_table
    assert_select "dt", :text => I18n.t('staff.travel_request.mileage_replace')
    assert_select "dd", :text => I18n.t('staff.travel_claim.for')
    assert_select "b", :text => I18n.t('staff.travel_claim.first_500')
    expect(rendered).to match("#{@travel_claim.km500}")
    expect(rendered).to match("#{@travel_claim.sen_per_km500}")
    assert_select "b", :text => I18n.t('staff.travel_claim.cent_per_km'), :count => 4 
    expect(rendered).to match("#{ringgols(@travel_claim.value_km500)}")
    assert_select "b", :text => "501 km - 1,000 km"
    expect(rendered).to match("#{@travel_claim.km1000}")
    expect(rendered).to match("#{@travel_claim.sen_per_km1000}")
    expect(rendered).to match("#{ringgols(@travel_claim.value_km1000)}")
    assert_select "b", :text => "1,001 km - 1,700 km"
    expect(rendered).to match("#{@travel_claim.km1700}")
    expect(rendered).to match("#{@travel_claim.sen_per_km1700}")
    expect(rendered).to match("#{ringgols(@travel_claim.value_km1700)}")
    assert_select "b", :text => I18n.t('staff.travel_claim.km1701_and_above')
    expect(rendered).to match("#{@travel_claim.kmmo}")
    expect(rendered).to match("#{@travel_claim.sen_per_kmmo}")
    expect(rendered).to match("#{ringgols(@travel_claim.value_kmmo)}")
    expect(rendered).to match("#{ringgols(@travel_claim.value_km)}")
    
    #tab_claims_details
    assert_select "b>u", :text => I18n.t('staff.travel_claim.receipts').upcase
    expect(rendered).to match("#{I18n.t('staff.travel_claim.type')}")
    expect(rendered).to match("#{I18n.t('staff.travel_claim.receipt_no')}")
    assert_select ".col-md-1", :text => I18n.t('staff.travel_claim.value')
    expect(rendered).to match("#{I18n.t('staff.travel_claim.claims_verification')}")
    expect(rendered).to match("#{(DropDown::RECEIPTTYPE.find_all{|disp, value| value == @travel_claim_receipt.expenditure_type}).map {|disp, value| disp}[0]}")
    expect(rendered).to match("#{@travel_claim_receipt.receipt_code}")
    expect(rendered).to match("#{ringgols(@travel_claim_receipt.amount)}")
    expect(rendered).to match("#{ringgols(@travel_claim.public_receipt_and_other_claims_receipt)}") #####
    expect(rendered).to match("#{ringgols(@travel_claim.receipts)}")
    expect(rendered).to match("#{ringgols(@travel_claim.total_km_money)}")
    expect(rendered).to match("#{ringgols(@travel_claim.public_receipt_only)}")
    expect(rendered).to match("#{ringgols(@travel_claim.other_claims_total)}")
    assert_select "dd", :text => I18n.t('staff.travel_claim.travel_log_val_rm_public_receipt_other_claims')
    
    #tab_advance
    assert_select "dt", :text => I18n.t('staff.travel_claim.advance').upcase
    assert_select "dd",:text => ringgols(@travel_claim.advance)
    assert_select "dt", :text => I18n.t('staff.travel_claim.current_total')
    assert_select "dd", :text => ringgols(@travel_claim.total_claims)
    assert_select "dt", :text => I18n.t('staff.travel_claim.claimable_total')
    assert_select "dd", :text => ringgols(@travel_claim.to_be_paid) 
    
    #tab_claims_approval
    assert_select "dt", :text => I18n.t('staff.travel_claim.is_submitted')
    expect(rendered).to match("#{I18n.t('staff.travel_claim.yes2')}")
    expect(rendered).to match("#{I18n.t('staff.travel_request.on2')}") 
    expect(rendered).to match("#{l(@travel_claim.submitted_on).to_s}")
    assert_select "dt", :text => I18n.t('staff.travel_claim.is_approved')
    expect(rendered).to match("#{I18n.t('staff.travel_claim.no2')}")
    #assert_select "dt", :text => I18n.t('staff.travel_claim.to_be_approved_by') 
    assert_select "dt", :text => "#{@travel_claim.is_approved? ?  (I18n.t 'staff.travel_claim.approved_by') : (I18n.t 'staff.travel_claim.to_be_approved_by')}"

    #page - buttons / links
    assert_select "a[href=?]", staff_travel_claims_path, {text: "#{I18n.t("helpers.links.back")}" }
    assert_select "a[href=?]", claimprint_staff_travel_claim_path(@travel_claim, format: "pdf")
    assert_select "a[href=?]", edit_staff_travel_claim_path(@travel_claim), {text: "#{I18n.t("helpers.links.edit")}" } 
    assert_select "a[href=?]", check_staff_travel_claim_path(@travel_claim), {text: "#{I18n.t("helpers.links.finance_check")}" }
    assert_select "a[href=?]", approval_staff_travel_claim_path(@travel_claim), {text: "#{I18n.t('helpers.links.approve')}" }
    assert_select "a[href=?]", staff_travel_claim_path(@travel_claim), {text: I18n.t("helpers.links.destroy")}
   
  end
end