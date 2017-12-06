require 'rails_helper'

RSpec.describe "staff/travel_requests/show", :type => :view do
  before(:each) do
    @admin_user=FactoryGirl.create(:admin_user)
    sign_in(@admin_user)
    @replacement = FactoryGirl.create(:basic_staff) 
    @hod = FactoryGirl.create(:basic_staff)
    @vehicle = FactoryGirl.create(:vehicle, reg_no: "JJJ1234", staffvehicle: @admin_user.userable)
    @travel_request = FactoryGirl.create(:travel_request, is_submitted: true, destination: 'some destination', depart_at: DateTime.now-2.days, return_at: DateTime.now-1.days , hod_accept: true, hod_accept_on: Date.today-3.days, applicant: @admin_user.userable, replacement: @replacement, headofdept: @hod, destination: "Putrajaya", dept_car: true) 
  end

  it "renders attributes in <dl>" do
    render
    
    assert_select "h1", :text => I18n.t('staff.travel_request.title')
    
    assert_select "dl>dt", :text => I18n.t('staff.travel_request.code')
    assert_select "dd", :text => @travel_request.code
      
    assert_select "dl>dt", :text => I18n.t('staff.travel_request.staff_id')
    assert_select "dd", :text => @travel_request.applicant.staff_with_rank_position_unit.strip
    
    assert_select "dl>dt", :text => I18n.t('staff.travel_request.document_id')
    assert_select "dd", :text => @travel_request.reference_document
    
    #tab_details
    assert_select "dl>dt", :text => I18n.t('staff.travel_request.destination')
    assert_select "dd", :text => @travel_request.destination
    
    assert_select "dl>dt", :text => I18n.t('staff.travel_request.depart_at' )
    assert_select "dd", :text => @travel_request.depart_at.try(:strftime, '%d-%m-%Y %H:%M')
    
    assert_select "dl>dt", :text =>I18n.t('staff.travel_request.return_at')
    assert_select "dd", :text => @travel_request.return_at.try(:strftime, '%d-%m-%Y %H:%M')
    
    #-->transport_choice
    assert_select "dl>dt", :text => I18n.t('staff.travel_request.transport_choice')
    # TODO     assert_select "dd", :text => "#{I18n.t('staff.travel_request.own_car')} "
    expect(rendered).to match("#{I18n.t('staff.travel_request.own_car')}") 
    expect(rendered).to match("#{I18n.t('staff.travel_request.dept_car')}")
    expect(rendered).to match("#{I18n.t('staff.travel_request.others_car')}")     
    
    #-->public_transport                                      
    assert_select "dl>dt", :text => I18n.t('staff.travel_request.public_transport')
    expect(rendered).to match("#{I18n.t('staff.travel_request.taxi')}")
    expect(rendered).to match("#{I18n.t('staff.travel_request.bus')}")
    expect(rendered).to match("#{I18n.t('staff.travel_request.train')}")
    expect(rendered).to match("#{I18n.t('staff.travel_request.plane')}")                         
    expect(rendered).to match("#{I18n.t('staff.travel_request.other')}")                 
          
    #tab_submission
    assert_select "dl>dt", :text => I18n.t('staff.travel_request.is_submitted')
    assert_select "dl>dt", :text => I18n.t('staff.travel_request.replaced_by')
    assert_select "dd", :text => @travel_request.try(:replacement).try(:staff_with_rank).strip
    
    #tab_approval
    assert_select "dl>dt", :text => I18n.t('staff.travel_request.approved_mileage')
    expect(rendered).to match("#{I18n.t('staff.travel_request.mileage')}")
    expect(rendered).to match("#{I18n.t('staff.travel_request.mileage_replace')}")
    assert_select "dl>dt", :text => I18n.t('staff.travel_request.hod_accept')
    
    assert_select "i.fa.fa-times", 8 #2(transport choice)+5(public transport),1(mileage_replace==nil, no request)
    assert_select "i.fa.fa-check", 3 #1(dept_car), 1(is_submitted), 1(hod_accept==true)
    
    # NOTE - current status: (mileage_replace==nil, mileage==nil)
    
    #page - buttons / links
    assert_select "a[href=?]", staff_travel_requests_path, {text: "#{I18n.t("helpers.links.back_travel_request")}" }
    assert_select "a[href=?]", travel_log_index_staff_travel_requests_path, {text: "#{I18n.t("helpers.links.back_travel_log")}" }
    
    assert_select "a[href=?]", status_movement_staff_travel_request_path(@travel_request, format: "pdf")
    assert_select "a[href=?]", travel_log_staff_travel_request_path(@travel_request), {text: "#{I18n.t('staff.travel_request.log_details')}" }
    assert_select "a[href=?]", staff_travel_request_path(@travel_request), {text: I18n.t("helpers.links.destroy")}
   
  end
end