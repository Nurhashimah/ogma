require 'rails_helper'

RSpec.describe "staff/staff_appraisals/index", :type => :view do
  
  before(:each) do
    @staff_user=FactoryGirl.create(:staff_user)
    sign_in(@staff_user)
    @staff_appraisal1=FactoryGirl.create(:staff_appraisal, staff_id: @staff_user.userable_id, evaluation_year: "2017-01-01")
    @staff_appraisal2=FactoryGirl.create(:staff_appraisal, staff_id: @staff_user.userable_id, evaluation_year: "2016-01-01")
    # NOTE :factory --> limit access to Edit page to PYD (edit -> is_skt_submit==false)
    @search=StaffAppraisal.search(params[:q])
    @staff_appraisals=@search.result.page(params[:page]).per(5)
  end

  it "renders a list of staff_appraisals" do
    render
    
    assert_select "h1", :text => I18n.t('staff.staff_appraisal.title')
    
    assert_select "tr>th>a", :text => I18n.t('staff.icno')
    assert_select "th>a", :text => I18n.t('staff.name')
    assert_select "th>a", :text => I18n.t('staff.position')
    assert_select "th>a", :text => I18n.t('helpers.label.staff_appraisal.evaluation_year')
    assert_select "th", :text => "Status"
    
    #This one also works
    #assert_select "a[href=?]", staff_staff_appraisal_path(@staff_appraisal1), :text => @staff_appraisal1.appraised.try(:formatted_mykad), :count => 1
    
    assert_select "tr>td>a", :text => @staff_appraisal1.appraised.try(:formatted_mykad)
    assert_select "tr>td>a", :text => @staff_appraisal2.appraised.try(:formatted_mykad)
    assert_select "td", :text => @staff_appraisal1.appraised.try(:name)
    assert_select "td", :text => @staff_appraisal2.appraised.try(:name)
    assert_select "td", :text => @staff_appraisal1.appraised.try(:position_for_staff)
    assert_select "td", :text => @staff_appraisal2.appraised.try(:position_for_staff)
    assert_select "td", :text => @staff_appraisal1.evaluation_year.try(:strftime, '%Y')
    assert_select "td", :text => @staff_appraisal2.evaluation_year.try(:strftime, '%Y')
    assert_select "td", :text => @staff_appraisal1.evaluation_status
    assert_select "td", :text => @staff_appraisal2.evaluation_status

  end
end