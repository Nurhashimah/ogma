# require 'rails_helper'
# 
# RSpec.describe "training/weeklytimetables/show", :type => :view do
#    before(:each) do
#     @staff_user=FactoryGirl.create(:staff_user)
#     sign_in(@staff_user)
#     @timetable_monthurs = FactoryGirl.create(:timetable)
#     @timetable_friday = FactoryGirl.create(:timetable)
#     @weeklytimetable = FactoryGirl.create(:weeklytimetable, :timetable_monthurs => @timetable_monthurs, :timetable_friday => @timetable_friday) 
#     @count1=@weeklytimetable.timetable_monthurs.timetable_periods.count
#     @count2=@weeklytimetable.timetable_friday.timetable_periods.count 
#   end
# 
#   it "renders attributes in <dl>" do
#     render
#     assert_select 'h1', text: I18n.t('training.weeklytimetable.title')
# #     expect(rendered).to match("#{@weeklytimetable.try(:schedule_programme).try(:programme_list)}")
#     assert_select "dd", text: @weeklytimetable.try(:schedule_programme).try(:programme_list)
#     expect(rendered).to match("#{@weeklytimetable.schedule_intake.siri_name}")
#     expect(rendered).to match("#{@weeklytimetable.try(:startdate).try(:strftime, "%d/%m/%Y")}")
#     expect(rendered).to match("#{@weeklytimetable.try(:enddate).try(:strftime, "%d/%m/%Y")}")
#     expect(rendered).to match("#{@weeklytimetable.schedule_creator.staff_with_rank.strip}")
#     expect(rendered).to match("#{@weeklytimetable.timetable_monthurs.name}")
#     expect(rendered).to match("#{@weeklytimetable.timetable_friday.name}") 
#   end
# end
# 
# 
# #   describe "Weeklytimetable Show page" do
# #     before { visit training_weeklytimetable_path(@weeklytimetable) }
# #     
# #     it { should have_selector('h1', text: I18n.t('training.weeklytimetable.title')) }
# #     it { should have_selector(:link_or_button, I18n.t("helpers.links.back"))}    
# #     #it { should have_selector(:link_or_button, I18n.t("helpers.links.edit"))}    
# #     #it { should have_selector(:link_or_button, I18n.t("helpers.links.destroy"))}  
# #     
# #   end