require 'rails_helper'

RSpec.describe "training/timetables/index", :type => :view do
  
  before(:each) do
    @admin_user=FactoryGirl.create(:admin_user)
    sign_in(@admin_user)
    @timetable1 = FactoryGirl.create(:timetable)
    @timetable2 = FactoryGirl.create(:timetable)
    @weeklytimetable=FactoryGirl.create(:weeklytimetable, format1: @timetable1.id, format2: @timetable2.id,is_submitted: true, hod_approved: true)
    @search=Timetable.search(params[:q])
    @timetables=@search.result.page(params[:page]).per(5)
  end

  it "renders a list of timetables" do
    render

    assert_select "h1", :text => I18n.t('training.timetable.title')
    
    assert_select "a[href=?]", new_training_timetable_path, :text => I18n.t("actions.new")
    assert_select "a", :text => I18n.t('actions.search')
    assert_select "a[href=?]", timetable_report_training_timetables_path(params.merge(format: 'pdf' )), :text => I18n.t('actions.print'), :count => 1
    
    #headers
    assert_select "tr>th", :text => "Status"
    assert_select "th>a", :text => I18n.t('training.timetable.code')
    assert_select "th>a", :text => I18n.t('training.timetable.name')
    assert_select "th>a", :text => I18n.t('training.timetable.description')
    assert_select "th>a", :text => I18n.t('training.timetable.created_by')
    
    #record lines
    assert_select "td>i.fa.fa-check-square", 2
    assert_select "td>a[href=?]", training_timetable_path(@timetable1), :text => @timetable1.code, :count => 1
    assert_select "td>a[href=?]", training_timetable_path(@timetable2), :text => @timetable2.code, :count => 1
    assert_select "td", :text => @timetable1.name
    assert_select "td", :text => @timetable2.name
    assert_select "td", :text => @timetable1.description
    assert_select "td", :text => @timetable2.description
    assert_select "td", :text => @timetable1.try(:creator).try(:name)
    assert_select "td", :text => @timetable2.try(:creator).try(:name)

  end
end