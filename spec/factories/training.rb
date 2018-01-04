# require 'spec_helper'
FactoryGirl.define do

  factory :academic_session do
    #semester {rand(1..2).to_s+"/"+(Date.today.year+rand(1..3)).to_s}
    semester {"1/#{Date.today.year}"}
    total_week {rand(20..30)}
  end

  factory :timetable do
    sequence(:code) { |n| "Some Code_#{n}"}
    sequence(:name) { |n| "Some Name_#{n}"}
    description "Some Description"
    association :creator, factory: :basic_staff  #(user not ready)
    association :college, factory: :college
    factory :timetable_w_period do
      after(:create) {|timetable| timetable_period = [create(:timetable_period, timetable: timetable)]}
    end
  end

  factory :intake do
#     name {Date.new(2014,rand(1..12),1).strftime("%b")+" "+(Date.today.year+rand(1..3)).to_s}
    sequence(:name) {|n| "#{n}/"+Date.today.year.to_s}
    description 4 #total division
    data {{:division =>{"0"=>{"name"=>"Bendahara", "total_student"=>"32"}, "1"=>{"name"=>"Temengong", "total_student"=>"32"}, "2"=>{"name"=>"Laksamana", "total_student"=>"32"}, "3"=>{"name"=>"Panglima", "total_student"=>"32"}}}}
    register_on {Date.today+(366*rand()).to_f}
    association :programme, factory: :programme
    is_active {rand(2) == 1}
    monthyear_intake {Date.today+(366*rand()).to_f} #{Date.new(Date.today.year+rand(1..3), [1,3,7,9].sample, 1)}
    association :college, factory: :college#, college_id: 1
    association :coordinator, factory: :basic_staff#, staff_id: 1
    #monthyear_intake {Date.new(Date.today.year+rand(1..3), [1,3,7,9][rand([1,3,7,9].length)], 1)}
  end

  factory :timetable_period do
    association :college, factory: :college
    association :timetable, factory: :timetable
    seq 1 # --OK 4 ... >> FactoryGirl.create(:lesson_plan), NOT OK 4 .. >>FactoryGirl.create(:timetable_period)
    #seq { rand(1..15) }  #-- reverse of above
    sequence(:sequence) { |n| "#{n}"}#+rand(1..15).to_s }     #NOTE - field name is 'sequence'
    day_name {[1,2].sample}
    end_at {Time.at(rand * Time.now.to_f)}
    start_at {Time.at(rand * Time.now.to_f)}
    is_break {rand(2) == 1}
  end

  #Programme
  factory :programme do
    sequence(:code) { |n| "0#{n}" }
    ancestry_depth 0
    sequence(:name) { |n| "Programme_#{n}"}
    duration 1
    durationtype {["hours", "weeks", "days", "months", "years"].sample}
    course_type {["Asas", "Pertengahan", "Lanjutan"].sample}
    association :college, factory: :college
    level "llp"
  end

#   kskbjb
#   if programme --> course type=diploma/pos basik/diploma lanjutan, ancestry depth=0
#   if semester --> course type=semester, ancestry_depth=1
#   if subject --> course_type=subject, ancestry_depth=2
#   if topic / subtopic --> course_type=topic, ancestry_depth=3

  factory :module, :class => 'Programme' do
    sequence(:code) {|n| "0#{n}"}
    association :parent, factory: :programme
    ancestry_depth 1
    sequence(:name) {|n| "Module_#{n}"}
    duration 1
    durationtype {["hours", "weeks", "days", "months"].sample}
    course_type "Module"
  end
  
  factory :subject, :class => 'Programme' do
    sequence(:code) {|n| "0#{n}"}
    association :parent, factory: :module
    ancestry_depth 2
    sequence(:name) {|n| "Subject_#{n}"}
    duration 1
    durationtype {["hours", "weeks", "days", "months"].sample}
    course_type "Subject"
  end
  
  factory :topic, :class => 'Programme' do
    sequence(:code) {|n| "0#{n}"}
    association :parent, factory: :subject
    ancestry_depth 3
    sequence(:name) {|n| "Topic_#{n}"}
    duration 1
    durationtype {["hours", "weeks", "days"].sample}
    course_type "Topic"
  end
  
  factory :subtopic, :class => 'Programme' do
    sequence(:code) {|n| "0#{n}"}
    association :parent, factory: :topic
    ancestry_depth 3
    sequence(:name) {|n| "Subtopic_#{n}"}
    duration 1
    durationtype {["hours", "weeks", "days"].sample}
    course_type "Subtopic"
  end
  
# Weeklytimetable.create(intake_id: 22, startdate: "2017/01/01", enddate: "2017/03/31", prepared_by:1588, format1: 228, format2: 229, college_id: 3143, programme_id: 70)

    factory :weeklytimetable, class: Weeklytimetable do
      #programme_id 1
#       intake_id 1
      association :schedule_intake, factory: :intake
      association :schedule_programme, factory: :programme
      startdate {Date.today+(366*rand()).to_f}
      enddate {Date.today+(366*rand())+(4*rand()).to_f}
      association :schedule_creator, factory: :basic_staff
#       association :schedule_approver, factory: :basic_staff
      association :timetable_monthurs, factory: :timetable_w_period
      association :timetable_friday, factory: :timetable_w_period
#       format1 1
#       format2 2
      association :college, factory: :college
#       week {rand(26)}
#       is_submitted {rand(2) == 1}
#       submitted_on {Date.today+(366*rand()).to_f}
#       hod_approved {rand(2) == 1}
#       hod_approved_on {Date.today+(366*rand()).to_f}
#       hod_rejected {rand(2) == 1}
#       hod_rejected_on {Date.today+(366*rand()).to_f}
#       reason "Some Reasons"
      after(:create) {|weeklytimetable| weeklytimetable_detail = [create(:weeklytimetable_detail, weeklytimetable: weeklytimetable)]}
    end

    factory :weeklytimetable_detail do
      #association :weeklytimetable_subject, factory: :programme
      #association :weeklytimetable_topic, factory: :programme
      association :weeklytimetable_lecturer, factory: :basic_staff
      association :weeklytimetable, factory: :weeklytimetable#, weeklytimetable_id: 1
      day2 {[1,2,3,4,6,7].sample}
      is_friday false #{rand(2) == 1}
#       sequence(:time_slot2 ) {|n| "#{n}"}
      time_slot2 1 #based on TimetablePeriod-sequence- default 1(monthurs)
      time_slot 0
      #association :monthurslot, factory: :timetable_period
      #association :fridayslot, factory: :timetable_period
      location "Some location"
      #association :weeklytimetable_location, factory: :location
      lecture_method {rand(1..3)}
    end

    factory :lesson_plan, class: LessonPlan do
      association :lessonplan_owner, factory: :basic_staff
      association :lessonplan_creator, factory: :basic_staff
      association :lessonplan_intake, factory: :intake #redundant with WT
      sequence(:student_qty) { |n| "#{n}" }
      semester {rand(1..6)}
      topic {|n| "#{n}"}#depends on relationship with weeklytimetable_details table
      lecture_title "Some Lecture Title"
      lecture_date {Date.today+(366*rand()).to_f}
      start_time {Time.at(rand * Time.now.to_f)}
      end_time {Time.at(rand * Time.now.to_f)}
      reference "Some Reference"
      is_submitted true
      association :endorser, factory: :basic_staff
      submitted_on {Date.today+(366*rand()).to_f}
      
      hod_approved true #{rand(2) == 1}
      hod_approved_on {Date.today+(366*rand()).to_f}
#       hod_rejected {rand(2) == 1}
#       hod_rejected_on {Date.today+(366*rand()).to_f}
      data_file_name "Some Name"
#       data_content_type { |n| "Some Content Type #{n}"}
      data_content_type "text/plain"
      data_file_size {rand(5242880)}
      data_updated_ot {Date.today+(366*rand()).to_f}
      prerequisites "Some prerequisite"
      year {rand(1..3)}
      reason "Some Reason"
      
      condition_isgood {rand(2) == 1}
      condition_isnotgood {rand(2) == 1}
      condition_desc "Some conditon description"
      training_aids "Some Training Aids"
      summary "Some Summary"
      sequence(:total_absent) {|n| "#{n}"}
      report_submit true #{rand(2) == 1}
      report_submit_on {Date.today+(366*rand()).to_f}
      report_endorsed true #{rand(2) == 1}
      report_endorsed_on {Date.today+(366*rand()).to_f}
      report_summary "Some Summary"
      
      association :schedule_item, factory: :weeklytimetable_detail
    end

end
