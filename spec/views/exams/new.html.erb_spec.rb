require 'rails_helper'

RSpec.describe "exam/exams/new", :type => :view do
  before(:each) do
    @admin_user=FactoryGirl.create(:admin_user)
    sign_in(@admin_user)
    @basic_staff=FactoryGirl.create(:basic_staff)
    @topic=FactoryGirl.create(:topic)
    @examquestion=FactoryGirl.create(:examquestion, topic_id: @topic.id, subject_id: @topic.parent_id, programme_id: @topic.root_id)
    #@examquestion.exams.last.update_attributes(name: "F", subject_id: @topic.parent_id, exam_on: "2017-12-01", starttime: "08:00:00",endtime: "10:00:00", created_by: @basic_staff.id)
    @exam=FactoryGirl.build(:exam, name: "F", subject_id: @topic.parent_id, exam_on: "2017-12-01", starttime: "08:00:00",endtime: "10:00:00", created_by: @basic_staff.id, examquestions: [@examquestion]) #Exam.last
    @programme_names=Programme.where(id: @topic.root_id).map(&:programme_list) 
    @subjects_paper=Programme.subject_groupbyoneprogramme2(@topic.root_id)
    
    finals_of_repeat=Exam.where(name: "R").pluck(:description)
    finals=[]
    finals_of_repeat.each{|y|finals << y.to_i}
    completed_finals=[]
    Exam.all.each{|x|completed_finals << x.id if x.complete_paper==true}
    subject_ids=Programme.where(id: @topic.root_id).first.descendants.where(course_type: 'Subject').pluck(:id)
     @final_exams=Exam.where(subject_id: subject_ids).where(name: "F").where.not(id: finals).where(id: completed_finals)
  end

  it "renders new exam form" do
    render

    assert_select "form[action=?][method=?]", exam_exams_path, "post" do

      assert_select "select#exam_name[name=?]", "exam[name]"
      assert_select "select#exam_created_by[name=?]", "exam[created_by]"
      assert_select "select#exam_course_id[name=?]", "exam[course_id]"
      assert_select "select#exam_subject_id[name=?]", "exam[subject_id]"   
      assert_select "input#exam_starttime[name=?]", "exam[starttime]"
      assert_select "input#exam_endtime[name=?]", "exam[endtime]"
     
    end
  end
end
