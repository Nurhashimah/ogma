# require 'rails_helper'
# 
# RSpec.describe "training/weeklytimetables/new", :type => :view do
#    before(:each) do
#     @staff_user=FactoryGirl.create(:staff_user)
#     sign_in(@staff_user)
#     @timetable_monthurs = FactoryGirl.create(:timetable)
#     @timetable_friday = FactoryGirl.create(:timetable)
#     @intake=FactoryGirl.create(:intake)
#     @weeklytimetable = FactoryGirl.build(:weeklytimetable, :timetable_monthurs => @timetable_monthurs, :timetable_friday => @timetable_friday, :intake_id => @intake.id) 
#     @intake_list=Intake.all.order(programme_id: :asc, monthyear_intake: :desc)
#     lecturer_ids=User.joins(:roles).where('roles.name=?','Lecturer').pluck(:userable_id)
#     @lecturer_list=Staff.joins(:positions).where('positions.name=? OR staffs.id IN(?)', 'Jurulatih', lecturer_ids)
#     @staffid=@staff_user.userable_id
#   end
# 
#   it "renders new weeklytimetable form" do
#     render
#     
#     assert_select 'h1', text: I18n.t('training.weeklytimetable.new'), :count => 1
# 
# 
#     assert_select "form[action=?][method=?]", training_weeklytimetables_path, "post" do
# 
#       assert_select "select#weeklytimetable_intake_id[name=?]", "weeklytimetable[intake_id]"
#       
#       assert_select "input#weeklytimetable_startdate[name=?]", "weeklytimetable[startdate]"
# 
#       assert_select "input#weeklytimetable_enddate[name=?]", "weeklytimetable[enddate]"
#       
#       assert_select "select#weeklytimetable_prepared_by[name=?]", "weeklytimetable[prepared_by]"
#       
#       assert_select "select#weeklytimetable_format1[name=?]", "weeklytimetable[format1]"
#       
#       assert_select "select#weeklytimetable_format2[name=?]", "weeklytimetable[format2]"
# 
#     end
#   end
# end