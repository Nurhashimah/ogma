require 'rails_helper'

RSpec.describe "staff/travel_claims/new", :type => :view do
  before(:each) do
    @admin_user=FactoryGirl.create(:admin_user)
    sign_in(@admin_user)
    ##
    @replacement = FactoryGirl.create(:basic_staff) 
    @hod = FactoryGirl.create(:basic_staff)
    @vehicle = FactoryGirl.create(:vehicle, reg_no: "JJJ1234", staffvehicle: @admin_user.userable)
    @travel_request = FactoryGirl.create(:travel_request, is_submitted: true, destination: 'some destination', depart_at: "2017-09-02 08:38:39", return_at: "2017-09-04 16:38:39" , hod_accept: true, hod_accept_on: Date.today-3.days, applicant: @admin_user.userable, replacement: @replacement, headofdept: @hod, destination: "Putrajaya", dept_car: true, travel_claim_id: nil) 
    ##
    @travel_claim = FactoryGirl.build(:travel_claim, staff: @admin_user.userable, claim_month: "2017-09-31")
    @my_approved_unclaimed_requests = TravelRequest.where('staff_id =? AND hod_accept=? and travel_claim_id is null', @admin_user.userable_id, true)
  end

  it "renders new travel_claim form" do
    render
puts "#{@my_approved_unclaimed_requests.count}"
    assert_select "h1", :text => I18n.t('staff.travel_claim.new')
    
    assert_select "form[action=?][method=?]", staff_travel_claims_path, "post" do
      
      assert_select "input#travel_claim_claim_month[name=?]", "travel_claim[claim_month]"
      assert_select "select#travel_claim_staff_id[name=?]", "travel_claim[staff_id]"
      assert_select "input#travel_request_ids_[name=?]", "travel_request_ids[]"
      assert_select "input#travel_claim_advance[name=?]", "travel_claim[advance]"
      assert_select "input#submit1[name=?]", "travel_claim[is_submitted]"
      
      assert_select "a[href=?]", staff_travel_claims_path, {text: I18n.t("helpers.links.back")}
      assert_select "input.btn.btn-primary[name=?][type=?][value=?]", "commit", "submit", I18n.t('create')

    end
  end
end