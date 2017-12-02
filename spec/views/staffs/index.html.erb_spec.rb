require 'rails_helper'

RSpec.describe "staff/staffs/index", :type => :view do
  
  before(:each) do
    @college=FactoryGirl.create(:college)
    @admin_user=FactoryGirl.create(:admin_user, college_id: @college.id)
    sign_in(@admin_user)
    @grade1=FactoryGirl.create(:employgrade)
    @grade2=FactoryGirl.create(:employgrade)
    @staff1=FactoryGirl.create(:basic_staff_with_position, college_id: @college.id, staffgrade_id: @grade1.id)
    @staff2=FactoryGirl.create(:basic_staff_with_position, college_id: @college.id, staffgrade_id: @grade2.id)
    @search=Staff.search(params[:q])
    @staffs=@search.result.page(params[:page]).per(5)
  end

  it "renders a list of staffs" do
    render

    #headers
    assert_select "h1", :text => I18n.t('staff.list')
    assert_select "a", :text => I18n.t('actions.search')
    assert_select "tr>th", :text => I18n.t('staff.icno')
    assert_select "th", :text => I18n.t('staff.staffgrade_id')
    assert_select "th", :text => I18n.t('staff.rank_id')
    assert_select "th", :text => I18n.t('staff.name')
    assert_select "th", :text => I18n.t('staff.position')
    
    #record lines
    assert_select "a[href=?]", staff_info_path(@staff1), :text => @staff1.try(:formatted_mykad), :count => 1
    assert_select "a[href=?]", staff_info_path(@staff2), :text => @staff2.try(:formatted_mykad), :count => 1

    assert_select "tr>td>a", :text => @staff1.try(:formatted_mykad)
    assert_select "tr>td>a", :text => @staff2.try(:formatted_mykad)
    assert_select "td", :text => @staff1.try(:staffgrade).try(:name)
    assert_select "td", :text => @staff2.staffgrade.try(:name)
    assert_select "td", :text => @staff1.try(:rank).try(:name)
    assert_select "td", :text => @staff2.try(:rank).try(:name)
    assert_select "td", :text => @staff1.name
    assert_select "td", :text => @staff2.name
    assert_select "td", :text => Position.where(id: @staff1.valid_posts).first.name if Position.where(id: @staff1.valid_posts).count > 0

  end
end