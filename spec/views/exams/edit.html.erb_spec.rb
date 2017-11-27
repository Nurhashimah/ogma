require 'rails_helper'

RSpec.describe "exam/exams/edit", :type => :view do
  before(:each) do
    @admin_user=FactoryGirl.create(:admin_user)
    sign_in(@admin_user)
    @basic_staff=FactoryGirl.create(:basic_staff)
    @topic=FactoryGirl.create(:topic)
    @examquestion=FactoryGirl.create(:examquestion, topic_id: @topic.id, subject_id: @topic.parent_id, programme_id: @topic.root_id)
    @examquestion.exams.last.update_attributes(name: "F", subject_id: @topic.parent_id, exam_on: "2017-12-01", starttime: "08:00:00",endtime: "10:00:00", created_by: @basic_staff.id)
    @exam=Exam.last
    
    @programme_names=Programme.where(id: @topic.root_id).map(&:programme_list) 
    @subjects=Programme.subject_groupbyoneprogramme2(@topic.root_id)
    @topics=Programme.topic_groupbysubject_oneprogramme(@topic.root_id)
     @items=Examquestion.all
    
#     @subjects_paper=Programme.subject_groupbyoneprogramme2(@topic.root_id)
#     finals_of_repeat=Exam.where(name: "R").pluck(:description)
#     finals=[]
#     finals_of_repeat.each{|y|finals << y.to_i}
#     completed_finals=[]
#     Exam.all.each{|x|completed_finals << x.id if x.complete_paper==true}
#     subject_ids=Programme.where(id: @topic.root_id).first.descendants.where(course_type: 'Subject').pluck(:id)
#      @final_exams=Exam.where(subject_id: subject_ids).where(name: "F").where.not(id: finals).where(id: completed_finals)
  end

  it "renders the edit exam form" do
    render

    assert_select "form[action=?][method=?]", exam_exam_path(@exam), "post" do

      assert_select "select#exam_topic_id[name=?]", "exam[topic_id]"  #ExamTemplate

      assert_select "select#course_name[name=?]", "course_name"
      assert_select "select#subjects[name=?]", "subjects"
      assert_select "select#topics[name=?]", "topics"
      
      assert_select "b", :text => I18n.t('exam.exams.existing')
      assert_select "td", :text =>@examquestion.questiontype
      assert_select "td", :text => "#{@examquestion.topic.parent.code}|#{@examquestion.topic.subject_list}"
      assert_select "td", :text => @examquestion.marks
      assert_select "input#exam_examquestion_ids_[name=?][value=?]", "exam[examquestion_ids][]", @examquestion.id

    end
  end
end
