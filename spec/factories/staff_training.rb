FactoryGirl.define do
  factory :ptbudget do
    budget {rand(10 ** 5)}
    fiscalstart {Time.at(rand * Time.now.to_f)}
  end
  
  factory :ptcourse do
    association :provider, factory: :address_book
    association :college, factory: :college
    sequence(:name) { |n| "Course#{n} From OS" }
    training_classification  1 #2 #3 #4 #{[1,2,3,4].sample} 
    #Training, Learning Session (Confront), Learning Session (Non Confront), Self - Training
    level {[1,2].sample} #Domestic, Overseas
    course_type {[1,2,3,4,5,6].sample} 
    #{[7,8,9,10,11,12].sample} #{[13,14,15,16,17].sample} #{[18,19,20,21,22].sample}
    #{[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22].sample} 
    #1)Latihan:Course, Seminar, Convention, Workshop, Forum, Symposium, 2)Bersemuka: Learning Session, Monthly Assembly, Special Talk, Celebration, Presentation, Speaker, 3)T/Bersemuka: Job Visit, On Job Training, Attachment Training, Simulation, Others, 4)Pembelajaran Kendiri: EPSA portal, E Learning Portal, HR Knowledge repo, Book Reading, Jurnal Reading
    duration 1
    duration_type {[0,1,2,3].sample} #hours, days, months, years
    sequence(:description) {|n| "Course description #{n}"}
    cost 500.00
    approved {rand(2) == 1}
  end
  
  factory :ptschedule do
    association :course, factory: :ptcourse
    start {Time.at(rand * Time.now.to_f)}
    location "location name"
    min_participants 1
    max_participants 20
  end
  
  factory :ptdo do
    association :college, factory: :college
#     association :staff, factory: :basic_staff
    association :applicant, factory: :basic_staff
    association :replacement, factory: :basic_staff
    association :ptschedule, factory: :ptschedule
    justification "My justification"
    #unit_review - not applicable -> default for amsas
    #unit_approve true - not applicable -> default for amsas
    #dept_review - not applicable -> default for amsas
    #dept_approve true - not applicable -> default for amsas
    final_approve nil
    trainee_report nil
  end
  
  
end