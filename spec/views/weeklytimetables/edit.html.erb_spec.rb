# require 'rails_helper'
# 
# RSpec.describe "training/weeklytimetables/edit", :type => :view do
#   before(:each) do
#     @staff_user=FactoryGirl.create(:staff_user)
#     sign_in(@staff_user)
#     @timetable_monthurs = FactoryGirl.create(:timetable)
#     @timetable_friday = FactoryGirl.create(:timetable)
#     @intake=FactoryGirl.create(:intake)
#     @weeklytimetable = FactoryGirl.create(:weeklytimetable, :timetable_monthurs => @timetable_monthurs, :timetable_friday => @timetable_friday, :intake_id => @intake.id) 
#     @intake_list=Intake.all.order(programme_id: :asc, monthyear_intake: :desc)
#     lecturer_ids=User.joins(:roles).where('roles.name=?','Lecturer').pluck(:userable_id)
#     @lecturer_list=Staff.joins(:positions).where('positions.name=? OR staffs.id IN(?)', 'Jurulatih', lecturer_ids)
#     @staffid=@staff_user.userable_id
#     @count1=@weeklytimetable.timetable_monthurs.timetable_periods.count
#     @count2=@weeklytimetable.timetable_friday.timetable_periods.count 
#     @break_format1 = @weeklytimetable.timetable_monthurs.timetable_periods.order(sequence: :asc).pluck(:is_break)
#     @break_format2 = @weeklytimetable.timetable_friday.timetable_periods.order(sequence: :asc).pluck(:is_break)
#     @timeslot = @weeklytimetable.timetable_monthurs.timetable_periods.where('is_break is false')
#     @timeslot2 = @weeklytimetable.timetable_friday.timetable_periods.where('is_break is false')
#     @special = @count1
#     @special2 = @count2
#     @semester_subject_topic_list=Programme.find(@weeklytimetable.programme_id).descendants.where(course_type: 'Subject').order('ancestry ASC, name ASC')
#     @is_creator=true
#   end
# 
#   it "renders the edit weeklytimetable form" do
#     render
# print page.html
#     assert_select 'h1', text: I18n.t('training.weeklytimetable.edit'), :count => 1
#     #below-show_main
#     assert_select "dd", text: @weeklytimetable.schedule_programme.programme_list
#     assert_select "dd", text: @weeklytimetable.schedule_intake.group_with_intake_name
#     assert_select "dd", text: @weeklytimetable.startdate.try(:strftime, "%d %b %Y") 
#     assert_select "dd", text: @weeklytimetable.enddate.try(:strftime, "%d %b %Y") 
#     assert_select "dd", text: @weeklytimetable.schedule_creator.staff_with_rank.strip
#     assert_select "dd", text: @weeklytimetable.timetable_monthurs.name
#     assert_select "dd", text: @weeklytimetable.timetable_friday.name
# 
#     assert_select "form[action=?][method=?]", training_weeklytimetable_path(@weeklytimetable), "post" do
# 
# #       first item
# #       assert_select "select#weeklytimetable_weeklytimetable_details_attributes_5_subject[name=?]", "weeklytimetable[weeklytimetable_details_attributes][5][subject]"
# 
#     end
#   end
# end
