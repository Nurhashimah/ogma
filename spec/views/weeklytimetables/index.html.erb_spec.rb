require 'rails_helper'

RSpec.describe "training/weeklytimetables/index", :type => :view do
  before(:each) do
    @staff_user=FactoryGirl.create(:staff_user)
    sign_in(@staff_user)
    @timetable_monthurs = FactoryGirl.create(:timetable)
    @timetable_friday = FactoryGirl.create(:timetable)
    @weeklytimetable1 = FactoryGirl.create(:weeklytimetable, :timetable_monthurs => @timetable_monthurs, :timetable_friday => @timetable_friday) 
    @weeklytimetable2 = FactoryGirl.create(:weeklytimetable, :timetable_monthurs => @timetable_monthurs, :timetable_friday => @timetable_friday) 
    @search=Weeklytimetable.search(params[:q])
    @weeklytimetables=@search.result.page(params[:page]).per(5)
  end

  it "renders a list of weeklytimetables" do
    render
    
    assert_select 'h1', text: I18n.t('training.weeklytimetable.title')
    assert_select 'th', text: I18n.t('training.weeklytimetable.programme_id')
    assert_select 'th', text: I18n.t('training.weeklytimetable.intake_id')
    assert_select 'th', text: I18n.t('training.weeklytimetable.startdate')
    assert_select 'th', text: I18n.t('training.weeklytimetable.enddate')
    assert_select 'th', text: "Format"
    assert_select 'th', text: I18n.t('training.weeklytimetable.prepared_by')
    assert_select 'th', text: I18n.t('training.weeklytimetable.is_submitted')
    assert_select 'th', text: I18n.t('training.weeklytimetable.is_approved')
    
#     should have_link(@weeklytimetable1.schedule_programme.programme_list), href: training_weeklytimetable_path(@weeklytimetable1.id) + "?locale=en" 
    
    assert_select "tr>td>a", :text => @weeklytimetable1.schedule_programme.programme_list, :count => 1
    assert_select "tr>td>a", :text => @weeklytimetable2.schedule_programme.programme_list, :count => 1
    assert_select "td", :text => @weeklytimetable1.schedule_intake.siri_name, :count => 1
    assert_select "td", :text => @weeklytimetable2.schedule_intake.siri_name, :count => 1
    assert_select "td", :text => @weeklytimetable1.timetable_monthurs.name, :count => 2
    assert_select "td", text: @weeklytimetable1.try(:startdate).try(:strftime, "%d-%m-%Y"), :count  => 1
    assert_select "td", text: @weeklytimetable2.try(:startdate).try(:strftime, "%d-%m-%Y"), :count  => 1
    assert_select "td", text: @weeklytimetable1.try(:enddate).try(:strftime, "%d-%m-%Y"), :count => 1 
    assert_select "td", text: @weeklytimetable2.try(:enddate).try(:strftime, "%d-%m-%Y"), :count => 1
    assert_select "td", text: @weeklytimetable1.schedule_creator.staff_with_rank.strip, :count => 1
    assert_select "td", text: @weeklytimetable2.schedule_creator.staff_with_rank.strip, :count => 1
    assert_select "td>i.fa.fa-times", 4
    
#     puts " - #{@weeklytimetable1.is_submitted} #{@weeklytimetable1.hod_rejected}"
    
  end
end
