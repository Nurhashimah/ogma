require 'rails_helper'

RSpec.describe "exam/exams/show", :type => :view do
  
  subject { page }
  before(:each) do
    @admin_user=FactoryGirl.create(:admin_user)
    sign_in(@admin_user)
    @basic_staff=FactoryGirl.create(:basic_staff)
    @topic=FactoryGirl.create(:topic)
    @examquestion=FactoryGirl.create(:examquestion, topic_id: @topic.id, subject_id: @topic.parent_id, programme_id: @topic.root_id)
    @examquestion.exams.last.update_attributes(name: "F", subject_id: @topic.parent_id, exam_on: "2017-12-01", starttime: "08:00:00",endtime: "10:00:00", created_by: @basic_staff.id)
    @exam=Exam.last
  end

  it "renders attributes in <p>" do
    render :template => 'exam/exams/amsas/show', :layout => false
    
#     puts "#{@exam.examquestions.last.course.try(:programme_list)}"
        
    assert_select "h1", :text => @exam.render_examtype[0], :count => 1
    assert_select "dd", :text =>  @exam.render_examtype[0], :count => 1
    
    expect(rendered).to match(@exam.render_examtype[0]), :count => 2
    expect(rendered).to match(@exam.subject.root.course_type)
    expect(rendered).to match(@exam.subject.subject_list)
    expect(rendered).to match(@exam.creator_details)
    expect(rendered).to match("01 Dec 2017")
    expect(rendered).to match("08:00 - 10:00")
    expect(rendered).to match(@exam.duration_in_str)
    expect(rendered).to match((@exam.duration/60).to_i.to_s+" hours "+(@exam.duration%60).to_i.to_s+" mins")
    expect(rendered).to match(number_with_precision(@exam.exam_template.template_full_marks, precision: 2))
    
  end
end
