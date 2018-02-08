require 'rails_helper'

RSpec.describe "training/timetables/edit", :type => :view do
  before(:each) do
    @admin_user=FactoryGirl.create(:admin_user)
    sign_in(@admin_user)
    @college=FactoryGirl.create(:college)
    @timetable = FactoryGirl.create(:timetable, college: @college)
    @timetable_period=FactoryGirl.create(:timetable_period, timetable: @timetable, is_break: true, non_class: 1, sequence: 1, seq: 1, start_at: "2017-01-01 06:00:00", end_at: "2017-01-01 06:30:00")
  end

  it "renders the edit timetable form" do
    render

    assert_select "h1", :text => "#{I18n.t('training.timetable.edit')}\n#{@timetable.name}"
    
    #the FORM starts here
    assert_select "form[action=?][method=?]", training_timetable_path(@timetable), "post" do
      
      assert_select "input#timetable_code[name=?]", "timetable[code]"
      assert_select "input#timetable_name[name=?]", "timetable[name]"
      assert_select "input#timetable_description[name=?]", "timetable[description]"   
      assert_select "select#timetable_created_by[name=?]", "timetable[created_by]"
      
      assert_select "b", :text => I18n.t('training.timetable_period.period')
      assert_select "b", :text => I18n.t('training.timetable_period.day_name')
      assert_select "b", :text => I18n.t('training.timetable_period.start_at')
      assert_select "b", :text => I18n.t('training.timetable_period.end_at')
      assert_select "b", :text => I18n.t('training.weeklytimetable.non_class')
      assert_select "b", :text => I18n.t('helpers.links.destroy')
      
      assert_select "select#timetable_timetable_periods_attributes_0_seq[name=?]", "timetable[timetable_periods_attributes][0][seq]"
      assert_select "select#timetable_timetable_periods_attributes_0_day_name[name=?]", "timetable[timetable_periods_attributes][0][day_name]"
      assert_select "input#timetable_timetable_periods_attributes_0_start_at[name=?]", "timetable[timetable_periods_attributes][0][start_at]"
      assert_select "input#timetable_timetable_periods_attributes_0_end_at[name=?]", "timetable[timetable_periods_attributes][0][end_at]"
      assert_select "input#timetable_timetable_periods_attributes_0_is_break[name=?]", "timetable[timetable_periods_attributes][0][is_break]"
      assert_select "select#timetable_timetable_periods_attributes_0_non_class[name=?]", "timetable[timetable_periods_attributes][0][non_class]"
      
      # buttons links
      assert_select "a[href=?]", training_timetable_path(@timetable), {text: I18n.t("helpers.links.back")}
      assert_select "input.btn.btn-primary[name=?][type=?][value=?]", "commit", "submit", I18n.t('update')
      
    end
    #the FORM ends here
    
  end
end