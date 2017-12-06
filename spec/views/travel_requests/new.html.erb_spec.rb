require 'rails_helper'

RSpec.describe "staff/travel_requests/new", :type => :view do
  before(:each) do
    @admin_user=FactoryGirl.create(:admin_user)
    sign_in(@admin_user)
    @replacement = FactoryGirl.create(:basic_staff) 
    @hod = FactoryGirl.create(:basic_staff)
    @vehicle = FactoryGirl.create(:vehicle, reg_no: "JJJ1234", staffvehicle: @admin_user.userable)
    @travel_request = FactoryGirl.build(:travel_request, is_submitted: true, destination: 'some destination', depart_at: DateTime.now-2.days, return_at: DateTime.now-1.days , hod_accept: true, hod_accept_on: Date.today-3.days, applicant: @admin_user.userable, replacement: @replacement, headofdept: @hod, destination: "Putrajaya", dept_car: true) 
    @staff_list=Staff.valid_staffs.order(rank_id: :asc, name: :asc)
  end

  it "renders new travel_request form" do
    render

    assert_select "h1", :text => I18n.t('staff.travel_request.new')
    
    assert_select "form[action=?][method=?]", staff_travel_requests_path, "post" do
      
      assert_select "input#travel_request_code[name=?]", "travel_request[code]"
      assert_select "select#travel_request_staff_id[name=?]", "travel_request[staff_id]"
      assert_select "select#travel_request_document_id[name=?]", "travel_request[document_id]"
      assert_select "input#travel_request_destination[name=?]", "travel_request[destination]"
      assert_select "input#travel_request_depart_at[name=?]", "travel_request[depart_at]"
      assert_select "input#travel_request_return_at[name=?]", "travel_request[return_at]"
      assert_select "input#mycar[name=?]", "travel_request[own_car]"
      assert_select "input#offcar[name=?]", "travel_request[dept_car]"
      assert_select "input#othcar[name=?]", "travel_request[others_car]"
      assert_select "input#travel_request_taxi[name=?]", "travel_request[taxi]"
      assert_select "input#travel_request_bus[name=?]", "travel_request[bus]"
      assert_select "input#travel_request_train[name=?]", "travel_request[train]"
      assert_select "input#travel_request_plane[name=?]", "travel_request[plane]"
      assert_select "input#other_transport[name=?]", "travel_request[other]"
      assert_select "input#check_submitted[name=?]", "travel_request[is_submitted]"
      assert_select "select#travel_request_replaced_by[name=?]", "travel_request[replaced_by]"
      assert_select "select#travel_request_hod_id[name=?]", "travel_request[hod_id]"
      
      assert_select "a[href=?]", staff_travel_requests_path, {text: I18n.t("helpers.links.back")}
      assert_select "input.btn.btn-primary[name=?][type=?][value=?]", "commit", "submit", I18n.t('create')

    end
  end
end