require 'spec_helper'

describe Exam do
  
  before(:each) do
    @admin_user=FactoryGirl.create(:admin_user)
    sign_in(@admin_user)
    @basic_staff=FactoryGirl.create(:basic_staff)
    @topic=FactoryGirl.create(:topic)
    @exam=FactoryGirl.create(:exam, programme: @topic.root, name: "F", subject_id: @topic.parent_id, exam_on: "2017-12-01", starttime: "08:00:00",endtime: "10:00:00", created_by: @basic_staff.id, sequ: "1,")
    @examquestion=FactoryGirl.create(:examquestion, topic_id: @topic.id, subject_id: @topic.parent_id, course: @topic.root, exams: [@exam])
  end
  
  subject { @exam }
  
  it { should respond_to(:course_id)}
  it { should respond_to(:name) } 
  it { should respond_to(:description) } 
  it { should respond_to(:created_by) } 
  it { should respond_to(:subject_id) } 
  it { should respond_to(:exam_on) } 
  it { should respond_to(:full_marks) } 
  it { should respond_to(:starttime) } 
  it { should respond_to(:endtime) } 
  it { should respond_to(:sequ) }
  it { should be_valid }

#   NOTE - validation already remove since subject_id validation added
#   describe "when programme id is not present" do
#     before {@exam.course_id = nil}
#     it { should_not be_valid }
#   end
  
  describe "when subject id is not present" do  # NOTE - name is "F" (not a repeat paper)
    before { @exam.subject_id = nil }
    it { should_not be_valid }
  end
  
  describe "when name is not present" do
    before { @exam.name = nil }
    it { should_not be_valid }
  end
  
  describe "when exam_on is not present" do
    before { @exam.exam_on = nil }
    it { should_not be_valid }
  end
  
  describe "when starttime is not present" do
    before { @exam.starttime = nil }
    it { should_not be_valid }
  end
  
  describe "when endtime is not present" do
    before { @exam.endtime = nil }
    it { should_not be_valid }
  end
  
  describe "when description is not present for repeat paper" do 
    before { @exam.name="R" }
    before { @exam.description = nil }
    it { should_not be_valid }
  end
 
  describe "when name is not unique within the same subject and exam date" do
    before { @exam2=FactoryGirl.build(:exam, programme: @topic.root, name: "F", subject_id: @topic.parent_id, exam_on: @exam.exam_on) }
    subject { @exam2 }
    it { should_not be_valid}
  end
  
  # TODO - next
  #didn't work yet - note - att_accessor : seq, table field : sequ
  #describe "when sequence is not present" do
    #before { @exam.sequ = "Select"} #before { @exam.seq == "Select"}
    #it { should_not be_valid} 
  #end
  
  #describe "when selected sequence is not unique" do
    ##before{ @exam.seq != "Select" && @exam.seq.uniq.length != @exam.seq.length}
    #before do
      #@exam.sequ = "1,2,3,4,5,6,7,8,9,9,9" 
      ##@exam.sequ.split(",").uniq.length < @exam.sequ.split(",").length 
      #a=@exam.sequ.split(",").length# = 10
      #b=@exam.sequ.split(",").uniq.length# = 9
      #a.should_not == b
      #end
    #it { should_not be_valid}
    #end  
  
end

#Validation failed: programme_id can't be blank, subject_id can't be blank, name can't be blank.
#Validation failed: name must be unique (within/for a) subject (subject_id).

#didn't work yet - note - att_accessor : seq, table field : sequ
#Validation failed: sequence can't be blank (must be selected) and sequence must be unique.


# == Schema Information
#
# Table name: exams
#
#  course_id   :integer
#  created_at  :datetime
#  created_by  :integer
#  description :text
#  duration    :integer
#  endtime     :time
#  exam_on     :date
#  full_marks  :integer
#  id          :integer          not null, primary key
#  klass_id    :integer
#  name        :string(255)
#  sequ        :string(255)
#  starttime   :time
#  subject_id  :integer
#  topic_id    :integer
#  updated_at  :datetime
#
