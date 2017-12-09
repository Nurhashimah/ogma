require 'rails_helper'

RSpec.describe "training/timetables/show", :type => :view do
  before(:each) do
    @admin_user=FactoryGirl.create(:admin_user)
    sign_in(@admin_user)
    @college=FactoryGirl.create(:college)
    @timetable = FactoryGirl.create(:timetable, college: @college)
    @timetable_period=FactoryGirl.create(:timetable_period, timetable: @timetable, is_break: true, non_class: 1, sequence: 1, seq: 1, start_at: "2017-01-01 06:00:00", end_at: "2017-01-01 06:30:00")
  end

  it "renders attributes in <dl>" do
    render
    
    assert_select "h1", :text => I18n.t('training.timetable.title')
      
    assert_select "dl>dt", :text => I18n.t('training.timetable.code')
    assert_select "dd", :text => @timetable.code
    assert_select "dl>dt", :text => I18n.t('training.timetable.name')
    assert_select "dd", :text => @timetable.name
    assert_select "dl>dt", :text => I18n.t('training.timetable.description')
    assert_select "dd", :text => @timetable.description
    assert_select "dl>dt", :text => I18n.t('training.timetable.created_by')
    assert_select "dd", :text => @timetable.try(:creator).try(:name)
    assert_select "dd>b", :text => I18n.t('training.timetable.period_timings')
    
    expect(rendered).to match("#{@timetable_period.sequence}")

    assert_select "td", :text => (TimetablePeriod::DAY_CHOICE2.find_all{|disp, value| value == (@timetable_period.day_name)}).map {|disp, value| disp}[0]
    expect(rendered).to match("<b>1</b>\n<BR>#{@timetable_period.start_at.try(:strftime, '%H:%M %P')} - </BR>\n#{@timetable_period.end_at.try(:strftime, "%H:%M %P")}\n<BR>\n#{@timetable_period.render_no_class}\n</BR>")
    
#     rendered format:
#        +<b>1</b>
#        +<BR>06:00 am - </BR>
#        +06:30 am
#        +<BR>
#        +SOLAT SUBUH BERJEMAAH DI MASJID
#        +</BR>
    
    #page - buttons / links
    assert_select "a[href=?]", training_timetables_path, {text: "#{I18n.t("helpers.links.back")}" }
    assert_select "a[href=?]", edit_training_timetable_path(@timetable), {text: I18n.t("helpers.links.edit")}
    assert_select "a[href=?]", training_timetable_path(@timetable), {text: I18n.t("helpers.links.destroy")}
   
  end
end

  