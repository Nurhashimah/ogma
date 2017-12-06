require 'rails_helper'

RSpec.describe "staff/travel_claims/edit", :type => :view do
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

  it "renders the edit travel_claim form" do
    render
    
    assert_select "h1", :text => "#{I18n.t('staff.travel_claim.edit')}"
    
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
    
    #the FORM starts here
    assert_select "form[action=?][method=?]", staff_travel_claim_path(@travel_claim), "post" do

      assert_select "input#travel_claim_claim_month[name=?]", "travel_claim[claim_month]"
      assert_select "input#travel_claim_staff_name[name=?]", "travel_claim[staff_name]"
      assert_select "textarea#travel_claim_accommodations[name=?]", "travel_claim[accommodations]"
      assert_select "input#travel_claim_advance[name=?]", "travel_claim[advance]"
      assert_select "input#submit1[name=?]", "travel_claim[is_submitted]"
      
      assert_select "a[href=?]", staff_travel_claim_path(@travel_claim), {text: I18n.t("helpers.links.back")}
#       also works
#       assert_select "a.btn.btn-default>i.fa.fa-arrow-left"
      
      assert_select "input.btn.btn-primary[name=?][type=?][value=?]", "commit", "submit", I18n.t('update')
      
    end
    #the FORM ends here
    
  end
end 
