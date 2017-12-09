require 'rails_helper'

RSpec.describe "training/timetables/new", :type => :view do
  before(:each) do
    @admin_user=FactoryGirl.create(:admin_user)
    sign_in(@admin_user)
    @college=FactoryGirl.create(:college)
    @timetable = FactoryGirl.build(:timetable, college: @college)
  end

  it "renders the edit timetable form" do
    render

    assert_select "h1", :text => I18n.t('training.timetable.new')
    
    #the FORM starts here
    assert_select "form[action=?][method=?]", training_timetables_path, "post" do
      
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
      
      # buttons links
      assert_select "a[href=?]", training_timetables_path, {text: I18n.t("helpers.links.back")}      
      assert_select "input.btn.btn-primary[name=?][type=?][value=?]", "commit", "submit", I18n.t('create')
      
    end
    #the FORM ends here
    
  end
end