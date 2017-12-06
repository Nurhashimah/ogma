require 'rails_helper'

RSpec.describe "staff/travel_requests/index", :type => :view do
  before(:each) do
    @admin_user=FactoryGirl.create(:admin_user)
    sign_in(@admin_user)
    @replacement = FactoryGirl.create(:basic_staff) 
    @hod = FactoryGirl.create(:basic_staff)
    @vehicle = FactoryGirl.create(:vehicle, reg_no: "JJJ1234", staffvehicle: @admin_user.userable)
    @vehicle2 = FactoryGirl.create(:vehicle, reg_no: "JKK 4545", staffvehicle: @admin_user.userable)
    #My Travel Request
    @travel_request1 = FactoryGirl.create(:travel_request, is_submitted: true, destination: 'some destination', depart_at: DateTime.now-62.days, return_at: DateTime.now-61.days , hod_accept: true, hod_accept_on: Date.today-63.days, applicant: @admin_user.userable, replacement: @replacement, headofdept: @hod, destination: "Putrajaya") 
    @travel_request2 = FactoryGirl.create(:travel_request, is_submitted: true, destination: 'some destination', depart_at: DateTime.now-32.days, return_at: DateTime.now-31.days , hod_accept: true, hod_accept_on: Date.today-33.days, applicant: @admin_user.userable, replacement: @replacement, headofdept: @hod, destination: "Putrajaya") 
    @travel_request3 = FactoryGirl.create(:travel_request, is_submitted: true, destination: 'some destination', depart_at: DateTime.now-2.days, return_at: DateTime.now-1.days , hod_accept: true, hod_accept_on: Date.today-3.days, applicant: @admin_user.userable, replacement: @replacement, headofdept: @hod, destination: "Putrajaya") 
    @search = TravelRequest.search(params[:q])
    @for_approvals = @search.result.in_need_of_approval(@admin_user.userable_id)
    @travel_requests = @search.result.my_travel_requests(@admin_user.userable_id)
    @other_travelrequests=@search.result.where.not(id: @for_approvals.pluck(:id)+@travel_requests.pluck(:id))
  end

  it "renders a list of travel_requests" do
    render
    
#     puts "#{@travel_requests.count} #{@travel_requests.first.id}~#{@travel_request1.id} je "
    
    assert_select "h1", :text => I18n.t('staff.travel_request.title')
    assert_select "a[href=?]", new_staff_travel_request_path, :text => I18n.t("actions.new")
    assert_select "a", :text => I18n.t('actions.search')
    assert_select "a[href=?]", travelrequest_list_staff_travel_requests_path(params.merge(format: 'pdf' )), :text => I18n.t('actions.print'), :count => 1
                                  
    assert_select "tr>th>a", :text => I18n.t('staff.travel_request.document_id')
    assert_select "th>a", :text => I18n.t('staff.travel_request.staff_id')
    assert_select "th>a", :text => I18n.t('staff.travel_request.destination')
    assert_select "th>a", :text => I18n.t('staff.travel_request.depart_at')
    assert_select "th>a", :text => I18n.t('staff.travel_request.return_at')
    assert_select "th>a", :text => I18n.t('staff.travel_request.purpose')
    assert_select "th>a", :text => I18n.t('staff.travel_request.is_submitted')
    assert_select "th>a", :text => I18n.t('staff.travel_request.hod_accept')
    
    #My Travel Requests - @travel_requests
    assert_select "td", :text => @travel_request1.try(:document).try(:refno)
    assert_select "td", :text => @travel_request2.try(:document).try(:refno)
    assert_select "td", :text => @travel_request3.try(:document).try(:refno)
    assert_select "td>a[href=?]", staff_travel_request_path(@travel_request1), :text => @travel_request1.applicant.try(:staff_with_rank).strip
    assert_select "td>a[href=?]", staff_travel_request_path(@travel_request2), :text => @travel_request2.applicant.try(:staff_with_rank).strip
    assert_select "td>a[href=?]", staff_travel_request_path(@travel_request3), :text => @travel_request3.applicant.try(:staff_with_rank).strip
    assert_select "td", :text => "Putrajaya", :count => 3
    assert_select "td", :text => @travel_request1.depart_at.try(:strftime, '%d-%m-%Y %H:%M')
    assert_select "td", :text => @travel_request2.depart_at.try(:strftime, '%d-%m-%Y %H:%M')
    assert_select "td", :text => @travel_request3.depart_at.try(:strftime, '%d-%m-%Y %H:%M')
    assert_select "td", :text => @travel_request1.return_at.try(:strftime, '%d-%m-%Y %H:%M')
    assert_select "td", :text => @travel_request2.return_at.try(:strftime, '%d-%m-%Y %H:%M')
    assert_select "td", :text => @travel_request3.return_at.try(:strftime, '%d-%m-%Y %H:%M')
    assert_select "td", :text => @travel_request1.document.try(:title)
    assert_select "td", :text => @travel_request2.document.try(:title)
    assert_select "td", :text => @travel_request3.document.try(:title)
    assert_select "td>i.fa.fa-check", 6
    assert_select "td>i.fa.fa-times", 0
  end
end