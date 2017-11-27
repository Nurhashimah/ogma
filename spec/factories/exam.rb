FactoryGirl.define do
  factory :exam do
    name "F" #{ ["M", "F", "R"].sample } #Repeat require additional validations - model line #168
    description "Exam Description"
    association :creator, factory: :basic_staff
    association :subject, factory: :subject
    association :exam_template, factory: :exam_template
    association :college, factory: :college
    klass_id 1 #0 #{[1,0].sample} #(with question / use of examtemplate)
    #subject_id 100 #if 1 is use - will failed - refer exams_controller.rb, line 92 (@programme_id = @exam.subject.root.id)
    exam_on {Date.today+(183*rand()).to_f}
    #full_marks rand(1..100) #{rand(1..100).to_f} - refer full_marks method in model/exam.rb
    starttime "08:00:00"#{Time.at(rand * Time.now.to_f)}
    endtime "10:00:00" #{Time.at(rand * Time.now.to_f)}   
    sequ "1,2,3,4,5,6,7,8,9,10" #"" #value is "", if klass_id==0
#     examquestions {[FactoryGirl.create(:examquestion)]} #HABTM - NOTE - use either one
  end
 
#   => Exam(id: integer, name: string, description: text, created_by: integer, course_id: integer, subject_id: integer, klass_id: integer, exam_on: date, duration: integer, full_marks: integer, starttime: time, endtime: time, topic_id: integer, sequ: string, created_at: datetime, updated_at: datetime, college_id: integer, data: string)
# >> 
#   
#   factory :examquestion_exam do
#     exam_id 1
#     examquestion_id 1
#   end

  #to use in examquestions views -> create topic first
  
#   Examquestion.create(creator_id: 87, approver_id: 88, editor_id: 89, programme_id: 146, subject_id: 148, topic_id: 149, questiontype: "MCQ", question: "Some question", answer: "Some answer", marks: 1, category: "Some category", qkeyword: "Some keyword", qstatus: "New", createdt: "2017-11-27")
  
#   FactoryGirl.create(:examquestion, creator_id: 87, approver_id: 88, editor_id: 89, programme_id: 146, subject_id: 148, topic_id: 149, questiontype: "MCQ", question: "Some question", answer: "Some answer", marks: 1, category: "Some category", qkeyword: "Some keyword", qstatus: "New", createdt: "2017-11-27")

  factory :examquestion do
    association :college, factory: :college
    association :creator, factory: :basic_staff
    association :approver, factory: :basic_staff
    association :editor, factory: :basic_staff
    association :course, factory: :programme
    association :subject, factory: :subject
    association :topic, factory: :topic

    questiontype "MCQ" #{["MCQ", "MEQ", "SEQ", "ACQ", "OSCI", "OSCII", "OSCE", "OSPE", "VIVA", "TRUEFALSE" ]}
    question "Some Question"
    answer "Some Answer"
    marks 1 #{rand(1.0..30.0).round(2)}
    category "Some Category"
    qkeyword "Some Keyword"
    qstatus "Created" #{  ["Created", "Submitted", "Edited", "Approved", "Reject at College", "Sent to KKM", "Sent to KKM", "Re-Edit", "Rejected" ] }
    #{ ["New", "Submit", "Editing", "Ready For Approval", "Re-Edit", "For Approval", "Approved", "Rejected"] } #"Some Status"
    
    createdt {Date.today+(183*rand()).to_f}
    difficulty "1" #{ ["1", "2", "3"] } #"Some Difficulty"
    statusremark "Some Status Remark"
    
    editdt {Date.today+(183*rand()).to_f}
    
    approvedt {Date.today+(183*rand()).to_f}
    bplreserve true #{rand(2)==1}
    bplsent true #{rand(2)==1}
    bplsentdt {Date.today+(183*rand()).to_f}
    diagram_file_name "Some Diagram Name"
    diagram_content_type "image/jpg"
    diagram_file_size 49000
    diagram_updated_at {Time.at(rand * Time.now.to_f)}
    
    construct "Some Construct"
    conform_curriculum {rand(2)==1}
    conform_specification {rand(2)==1}
    conform_opportunity {rand(2)==1}
    accuracy_construct {rand(2)==1}
    accuracy_topic {rand(2)==1}
    accuracy_component {rand(2)==1}
    fit_difficulty {rand(2)==1}
    fit_important {rand(2)==1}
    fit_fairness {rand(2)==1}
    diagram_caption "Some diagram caption"
    exams {[FactoryGirl.create(:exam)]} #HABTM
  end
  
  factory :exam_template do
    association :creator, factory: :staff_user
    sequence(:name) { |n| "Template #{n}" }
    data {{:question_count=>{"mcq"=>{"count"=>"2", "weight"=>"40", "full_marks"=>"2"}}}}
  end
end


#sequence(:coemail) { |n| "slatest#{n}@example.com" }
#sequence(:name) { |n| "Bob#{n} Uncle" }
#icno {(0...12).map {rand(10).to_s}.join }
#code {(0...8).map { (65 + rand(26)).chr }.join}
#appointdt {Time.at(rand * Time.now.to_f)}
#cobirthdt {Time.at(rand * Time.now.to_f)}
#addr "Some Address"
#poskod_id {rand(10 ** 5).to_s}
#staffgrade_id 1 #make factory
#statecd 1
#country_id 1
#country_cd 1
#fileno {(0...8).map { (65 + rand(26)).chr }.join}


# == Schema Information
#
# Table name: examquestions
#
#  accuracy_component    :boolean
#  accuracy_construct    :boolean
#  accuracy_topic        :boolean
#  answer                :text
#  approvedt             :date
#  approver_id           :integer
#  bplreserve            :boolean
#  bplsent               :boolean
#  bplsentdt             :date
#  category              :string(255)
#  conform_curriculum    :boolean
#  conform_opportunity   :boolean
#  conform_specification :boolean
#  construct             :string(255)
#  created_at            :datetime
#  createdt              :date
#  creator_id            :integer
#  diagram_caption       :string(255)
#  diagram_content_type  :string(255)
#  diagram_file_name     :string(255)
#  diagram_file_size     :integer
#  diagram_updated_at    :datetime
#  difficulty            :string(255)
#  editdt                :date
#  editor_id             :integer
#  fit_difficulty        :boolean
#  fit_fairness          :boolean
#  fit_important         :boolean
#  id                    :integer          not null, primary key
#  marks                 :decimal(, )
#  programme_id          :integer
#  qkeyword              :string(255)
#  qstatus               :string(255)
#  question              :text
#  questiontype          :string(255)
#  statusremark          :text
#  subject_id            :integer
#  topic_id              :integer
#  updated_at            :datetime
#

#== Schema Information
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

