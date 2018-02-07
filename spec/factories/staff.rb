FactoryGirl.define do

  # Staffs
#   astaff=Staff.new(name: 'nama 1', coemail: 'latest@example.com', icno: '123456789012', code: "123456789012", appointdt: "2012-01-01", current_salary: 1100.00, country_cd: 1, staffgrade_id: 1)

  factory :basic_staff, :class => 'Staff' do
    sequence(:coemail) { |n| "slatest#{n}@example.com" }
    sequence(:name) { |n| "Bob#{n} Uncle" }
    icno {(0...12).map {rand(10).to_s}.join }
    code {(0...8).map { (65 + rand(26)).chr }.join}
    appointdt {Time.at(rand * Time.now.to_f)}
    cobirthdt {Time.at(rand * Time.now.to_f)}
    addr "Some Address"
    poskod_id {rand(10 ** 5).to_s}
    statecd 1
    country_id 1
    country_cd 1
    fileno {(0...8).map { (65 + rand(26)).chr }.join}
    current_salary {rand(300..15000)}
    association :staffgrade, factory: :employgrade
    association :college, factory: :college
    thumb_id {(0...4).map {rand(10).to_s}.join }#"9012"
    #association :timetables, factory: :timetable
    factory :basic_staff_with_position do
      after(:create) {|basic_staff| create(:position, staff: basic_staff)}
    end
    factory :basic_staff_with_rank do
      association :rank, factory: :rank
#       after(:create) {|basic_staff| create(:rank, staff: basic_staff)}
    end
  end

  factory :staff_with_login, :class => 'Staff' do
    sequence(:coemail) { |n| "slatest#{n}@example.com" }
    sequence(:name) { |n| "Bob#{n} Uncle" }
    icno {(0...12).map {rand(10).to_s}.join }
    code {(0...8).map { (65 + rand(26)).chr }.join}
    appointdt {Time.at(rand * Time.now.to_f)}
    cobirthdt {Time.at(rand * Time.now.to_f)}
    addr "Some Address"
    poskod_id {rand(10 ** 5).to_s}
    statecd 1
    country_id 1
    country_cd 1
    fileno {(0...8).map { (65 + rand(26)).chr }.join}
    current_salary {rand(300..15000)}
    association :staffgrade, factory: :employgrade
    after(:create) {|staff| staff.users = [create(:staff_user)]}
    after(:create) {|staff| staff.vehicles = [create(:vehicle)]}
    #association :timetables, factory: :timetable
  end

  factory :vehicle, :class => 'Vehicle' do
    sequence(:type_model)  { |n| "Reg No #{n}" }
    sequence(:reg_no) { |n| "Reg No #{n}" }
    cylinder_capacity {rand(60..3000)}
    #association :staffvehicle, factory: :basic_staff
    #staff_id 25
  end

#   agrade=Employgrade.new(name: 'grade 11', group_id: 1)
  factory :employgrade do
#     name {|n| "Grade Name #{[1,2].sample}#{n}"}
    sequence(:name) {|n| "Grade Name 4#{n}" }
    group_id {[1,2,4].sample}
  end

  factory :position do
    sequence(:name) { |n| "Position#{n} Orgchart" }
    sequence(:code) { |n| "Code#{n}" }
    sequence(:tasks_main) {|n| "Task #{n}"}
    sequence(:combo_code) {|n| "0-#{n}"}
    association :college, factory: :college
    association :staff, factory: :basic_staff
    association :staffgrade, factory: :employgrade #min grade
  end
  
  factory :rank do
    association :staffgrade, factory: :employgrade
    sequence(:name) {|n| "Name #{n}"}
    sequence(:shortname) {|n| "Short Name #{n}"}
    category {[1,2].sample}
    association :college, factory: :college
  end
  
  factory :title do
    sequence(:titlecode) {|n| "Title Code #{n}"}
    name {['Tun', 'Cik', 'Puan', 'Hajjah', 'Encik', 'Tuan', 'Haji', 'Doktor', 'Dato'].sample}
    berhormat {rand(2) == 1}
    association :college, factory: :college
  end
  
  factory :qualification_level, :class => 'Qualification' do
    level_id {[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17].sample}
    sequence(:qname) { |n| "Qualification #{n}" }
    sequence(:institute) { |n| "Institute Name #{n}" }
    factory :staff_qualification do
      association :staff, factory: :basic_staff
    end
#     HOLD FIRST - student (factory to create)
#     factory :qualification_student do
#       association :student, factory: :student
#     end
  end
  
  factory :bankaccount do
    sequence(:account_no) {|n| "Account #{n}"}
    account_type {[1,2,3,4].sample}
    association :bank, factory: :bank
    factory :staff_bankaccount do
      association :staff, factory: :basic_staff
    end
#     NOTE - student_id field in table
#     factory :student_bankaccount do
#     end
  end
  
  factory :insurance_policy do
    association :staff, factory: :basic_staff
    association :insurance_company, factory: :insurance_company
    sequence(:policy_no) {|n| }
  end
  
  factory :loan do
    association :staff, factory: :basic_staff
    sequence(:accno) {|n| "Loan No #{n}"}
    amount 1200.00
    deductions 120.00
    durationmn 12
    enddate "2018-10-01"
    enddeduction 120.00
    firstdate "2017-12-01"
    ltype 1 #{[1,2,3,4,99]}
    startdt "2018-01-01"
  end

  factory :staff_attendance do
    #sequence(:thumb_id) { |n| }
    association :attended, factory: :basic_staff
    logged_at {Time.at(rand * Time.now.to_f)}
    log_type "Some Type"
    reason "Some Reason"
    trigger {rand(2) == 1}
    association :approver, factory: :basic_staff
    is_approved {rand(2) == 1}
    approved_on {Date.today+(366*rand()).to_f}
    status 1
    review "Some Review"
  end

#   app=StaffAppraisal.new(staff_id: 1, evaluation_year: "2011-01-01")
  factory :staff_appraisal do
    association :appraised, factory: :basic_staff
    association :eval1_officer, factory: :basic_staff
    association :eval2_officer, factory: :basic_staff
    evaluation_year {(Date.today+(366*rand()).to_f).at_beginning_of_month}
    is_skt_submit false #true #{rand(2) == 1}
    skt_submit_on {Date.today+(366*rand()).to_f}
    is_skt_endorsed false # true #{rand(2) == 1}
    skt_endorsed_on {Date.today+(366*rand()).to_f}
    skt_pyd_report "Some PYD Report"
    is_skt_pyd_report_done true #{rand(2) == 1}
    skt_pyd_report_on {Date.today+(366*rand()).to_f}
    skt_ppp_report "Some PPP Report"
    is_skt_ppp_report_done true #{rand(2) == 1}
    skt_ppp_report_on {Date.today+(366*rand()).to_f}
    is_submit_for_evaluation true #{rand(2) ==1}
    submit_for_evaluation_on {Date.today+(366*rand()).to_f}
    g1_questions 5
    g2_questions {rand(3..4)}
    g3_questions {rand(3..5)}
    e1g1q1 {rand(0..10).to_f}
    e1g1q2 {rand(0..10).to_f}
    e1g1q3 {rand(0..10).to_f}
    e1g1q4 {rand(0..10).to_f}
    e1g1q5 {rand(0..10).to_f}
    e1g1_total {rand(0..50).to_f}
    e1g1_percent {rand(0..50).to_f}
    e1g2q1 {rand(0..10).to_f}
    e1g2q2 {rand(0..10).to_f}
    e1g2q3 {rand(0..10).to_f}
    e1g2q4 {rand(0..10).to_f}
    e1g2_total {rand(0..40).to_f}
    e1g2_percent {rand(0..25).to_f}
    e1g3q1 {rand(0..10).to_f}
    e1g3q2 {rand(0..10).to_f}
    e1g3q3 {rand(0..10).to_f}
    e1g3q4 {rand(0..10).to_f}
    e1g3q5 {rand(0..10).to_f}
    e1g3_total {rand(0..50).to_f}
    e1g3_percent {rand(0..20).to_f}
    e1g4 {rand(0..10).to_f}
    e1g4_percent {rand(0..5).to_f}
    e1_total {rand(0..100).to_f}
    e1_years 0 #{rand(0..45)}
    e1_months {rand(1..12)}
    e1_performance "Some Performance"
    e1_progress "Some Progress"
    is_submit_e2 true # {rand(2)==1}
    submit_e2_on {Date.today+(366*rand()).to_f}

    e2g1q1 {rand(0..10).to_f}
    e2g1q2 {rand(0..10).to_f}
    e2g1q3 {rand(0..10).to_f}
    e2g1q4 {rand(0..10).to_f}
    e2g1q5 {rand(0..10).to_f}
    e2g1_total {rand(0..50).to_f}
    e2g1_percent {rand(0..50).to_f}
    e2g2q1 {rand(0..10).to_f}
    e2g2q2 {rand(0..10).to_f}
    e2g2q3 {rand(0..10).to_f}
    e2g2q4 {rand(0..10).to_f}
    e2g2_total {rand(0..40).to_f}
    e2g2_percent {rand(0..25).to_f}
    e2g3q1 {rand(0..10).to_f}
    e2g3q2 {rand(0..10).to_f}
    e2g3q3 {rand(0..10).to_f}
    e2g3q4 {rand(0..10).to_f}
    e2g3q5 {rand(0..10).to_f}
    e2g3_total {rand(0..50).to_f}
    e2g3_percent {rand(0..20).to_f}
    e2g4 {rand(0..10).to_f}
    e2g4_percent {rand(0..5).to_f}
    e2_total {rand(0..100).to_f}
    e2_years 0 #{rand(0..45)}
    e2_months {rand(1..12)}
    e2_performance "Some Performance 2"
    evaluation_total 1.0
    is_complete true #{rand(2)==1}
    is_completed_on {Date.today+(366*rand()).to_f}
    
    after(:create) {|appraisal| appraisal.staff_appraisal_skts = [create(:staff_appraisal_skt, staff_appraisal_id: appraisal.id)]}
  end
  
  factory :staff_appraisal_skt do
    association :staff_appraisal, factory: :staff_appraisal
    priority 1
    half 1
    is_dropped false
    dropped_on nil
    drop_reasons ""
    indicator_desc_cost "cost indicator"
    indicator_desc_quality "quality indicator"
    indicator_desc_quantity "quantity indicator"
    indicator_desc_time "time indicator"
    target_cost "cost target"
    target_quality "quality target"
    target_quantity "quantity target"
    target_time "time target"
    achievement_cost "cost achievement"
    achievement_quality "quality achievement"
    achievement_quantity "quantity achievement"
    achievement_time  "time achievement"
    progress_cost 80.0
    progress_quality 80.0
    progress_quantity 80.0
    progress_time 80.0
    notes_cost "cost notes"
    notes_quality "quality notes"
    notes_quantity "quantity notes"
    notes_time "time quantity"
    description "SKT description"
    data "My Text"
    #college_id 1
    
#     => StaffAppraisalSkt(id: integer, staff_appraisal_id: integer, priority: integer, half: integer, is_dropped: boolean, dropped_on: date, drop_reasons: string, created_at: datetime, updated_at: datetime, indicator_desc_quality: string, indicator_desc_time: string, indicator_desc_quantity: string, indicator_desc_cost: string, target_quality: string, target_time: string, target_quantity: string, target_cost: string, achievement_quality: string, achievement_time: string, achievement_quantity: string, achievement_cost: string, progress_quality: decimal, progress_time: decimal, progress_quantity: decimal, progress_cost: decimal, notes_quantity: string, notes_time: string, notes_quality: string, notes_cost: string, description: text, college_id: integer, data: string)

  end

  factory :travel_request, :class => 'TravelRequest' do
    association :applicant, factory: :basic_staff #staff_with_login
    association :replacement, factory: :basic_staff
    association :headofdept, factory: :basic_staff
    association :college, factory: :college
    #association :travel_claim, factory: :travel_claim
    #association :document, factory: :document
    destination "Some destination"
    depart_at {DateTime.now-2.days}
    return_at {DateTime.now-1.days}
    #depart_at {DateTime.now-(366*rand()).to_f}
    #return_at {DateTime.now-(366*rand()).to_f}
    #own_car {rand(2)==1}
    #own_car_notes "Some notes"
    #dept_car {rand(2)==1}
    #others_car {rand(2)==1}
    #taxi {rand(2)==1}
    #bus {rand(2)==1}
    #train {rand(2)==1}
    #plane {rand(2)==1}
    #other {rand(2)==1}
    #other_desc "Some description"
    #is_submitted {rand(2)==1}
    #submitted_on {Date.today+(366*rand()).to_f}
    #mileage {rand(2)==1}
    #mileage_replace {rand(2)==1}
    #hod_accept {rand(2)==1}
    #hod_accept_on {Date.today+(366*rand()).to_f}
    #is_travel_log_complete {rand(2)==1}
    #log_mileage {rand(0..2500).to_f}
    #log_fare {rand(0..5000).to_f}
    #code "Some code"
  end

  factory :travel_claim do
    association :staff, factory: :basic_staff
    association :approver, factory: :basic_staff
    claim_month {Date.today-(366*rand()).to_f}
    advance {rand(0..1000).to_f}
    total {rand(0..5000).to_f}
    is_submitted {rand(2)==1}
    submitted_on {Date.today+(366*rand()).to_f}
    is_checked {rand(2)==1}
    is_returned {rand(2)==1}
    checked_on {Date.today+(366*rand()).to_f}
    notes "Some notes"
    is_approved {rand(2)==1}
    approved_on {Date.today+(366*rand()).to_f}
  end
  
  factory :travel_claim_log do
    association :travel_request, factory: :travel_request
    travel_on {Date.today-2.days}
    start_at {DateTime.now-2.days} #"2000-01-01 23:15:00"
    finish_at {DateTime.now-2.days+1.hours}
    destination "From A to B"
    mileage 50.0
    km_money nil
    checker {rand(2)==1}
    checker_notes "Some notes"
  end
  
  factory :travel_claim_receipt do
    association :travel_claim, factory: :travel_claim
    expenditure_type {[00, 11, 12, 13, 14, 15, 19, 40, 41, 42, 43, 44, 45, 99].sample}# 11 #teksi
    sequence(:receipt_code) {|n| "Receipt code #{n}"}
    spent_on {Date.today+(366*rand()).to_f} #"2017-09-03"
    amount 20.00
    quantity 1.00
  end
  
  factory :instructor_appraisal do
    association :checker, factory: :basic_staff_with_rank
    association :instructor, factory: :basic_staff_with_rank
    association :college, factory: :college
    appraisal_date {Date.today+(366*rand()).to_f}
  end
  
  factory :average_instructor do
    association :college, factory: :college
    association :instructor, factory: :basic_staff_with_rank
    association :programme, factory: :programme
    association :evaluator, factory: :basic_staff_with_rank
    delivery_type 1 #{ [1,2,3].sample}  1-Teori, 2-Praktikal, 3-Lain-lain
    evaluate_date "2017-11-24"
    start_at "08:00:00"
    end_at "08:30:00"
    title "My Title"
    objective "Objective line"
    pbq1 3
    pbq2 3
    pbq3 3
    pbq4 3
    pbq1review "pbq1review"
    pbq2review "pbq2review"
    pbq3review "pbq3review" 
    pbq4review "pbq4review" 
    pdq1 3 
    pdq2 3 
    pdq3 3
    pdq4 3
    pdq5 3
    pdq1review "pdq1review"
    pdq2review "pdq2review"
    pdq3review "pdq3review"
    pdq4review "pdq4review"
    pdq5review "pdq5review"
    dq1 3
    dq2 3
    dq3 3
    dq4 3 
    dq5 3 
    dq6 3 
    dq7 3 
    dq8 3  
    dq9 3 
    dq10 3 
    dq11 3 
    dq12 3 
    dq1review "dq1review" 
    dq2review "dq2review" 
    dq3review "dq3review" 
    dq4review "dq4review" 
    dq5review "dq5review" 
    dq6review "dq6review" 
    dq7review "dq7review" 
    dq8review "dq8review" 
    dq9review "dq9review" 
    dq10review "dq10review" 
    dq11review "dq11review" 
    dq12review "dq12review" 
    uq1 3
    uq2 3 
    uq3 3 
    uq4 3 
    uq1review "uq1review" 
    uq2review "uq2review" 
    uq3review "uq3review" 
    uq4review "uq4review" 
    vq1 3 
    vq2 3 
    vq3 3 
    vq4 3 
    vq5 3 
    vq1review "vq1review" 
    vq2review "vq2review" 
    vq3review "vq3review" 
    vq4review "vq4review" 
    vq5review "vq5review" 
    gttq1 3 
    gttq2 3 
    gttq3 3 
    gttq4 3 
    gttq5 3 
    gttq6 3 
    gttq7 3 
    gttq8 3 
    gttq9 3 
    gttq1review "gttq1review" 
    gttq2review "gttq2review" 
    gttq3review "gttq3review" 
    gttq4review "gttq4review" 
    gttq5review "gttq5review" 
    gttq6review "gttq6review" 
    gttq7review "gttq7review" 
    gttq8review "gttq8review" 
    gttq9review "gttq9review" 
    review "Overall review" 
    data "My text"
    
#     => AverageInstructor(id: integer, programme_id: integer, instructor_id: integer, evaluate_date: date, title: string, objective: text, start_at: time, end_at: time, delivery_type: integer, pbq1: integer, pbq2: integer, pbq3: integer, pbq4: integer, pbq1review: string, pbq2review: string, pbq3review: string, pbq4review: string, pdq1: integer, pdq2: integer, pdq3: integer, pdq4: integer, pdq5: integer, pdq1review: string, pdq2review: string, pdq3review: string, pdq4review: string, pdq5review: string, dq1: integer, dq2: integer, dq3: integer, dq4: integer, dq5: integer, dq6: integer, dq7: integer, dq8: integer, dq9: integer, dq10: integer, dq11: integer, dq12: integer, dq1review: string, dq2review: string, dq3review: string, dq4review: string, dq5review: string, dq6review: string, dq7review: string, dq8review: string, dq9review: string, dq10review: string, dq11review: string, dq12review: string, uq1: integer, uq2: integer, uq3: integer, uq4: integer, uq1review: string, uq2review: string, uq3review: string, uq4review: string, vq1: integer, vq2: integer, vq3: integer, vq4: integer, vq5: integer, vq1review: string, vq2review: string, vq3review: string, vq4review: string, vq5review: string, gttq1: integer, gttq2: integer, gttq3: integer, gttq4: integer, gttq5: integer, gttq6: integer, gttq7: integer, gttq8: integer, gttq9: integer, gttq1review: string, gttq2review: string, gttq3review: string, gttq4review: string, gttq5review: string, gttq6review: string, gttq7review: string, gttq8review: string, gttq9review: string, review: text, evaluator_id: integer, created_at: datetime, updated_at: datetime, college_id: integer, data: text)

  end
  
#   factory :leaveforstaff do
#     association :applicant, factory: :basic_staff
#     association :replacement, factory: :basic_staff
#     association :seconder, factory: :basic_staff
#     association :approver, factory: :basic_staff
#     association :college, factory: :college
#     leavetype 1
#     leavestartdate {Date.today.tomorrow+(366*rand()).to_f}
#     leaveenddate {Date.today+2.days+(366*rand()).to_f}
#     leavedays 1.0
#     reason "Some reason"
#     notes "Some notes"
#     submit {rand(2)==1}
#     approval1 {rand(2)==1}
#     approval1date {Date.today+(366*rand()).to_f}
#     approver2 {rand(2)==1}
#     approval2date {Date.today+(366*rand()).to_f}
#     data {{}}
#     address_on_leave "Some address"
#     phone_on_leave (0...12).map {rand(10).to_s}.join
#   end

end



#
#

    # == Schema Information
    #
    # Table name: staffs
    #
    #  addr                    :string(255)
    #  appointby               :string(255)
    #  appointdt               :date
    #  appointstatus           :string(255)
    #  att_colour              :integer
    #  bank                    :string(255)
    #  bankaccno               :string(255)
    #  bankacctype             :string(255)
    #  birthcertno             :string(255)
    #  bloodtype               :string(255)
    #  cobirthdt               :date
    #  code                    :string(255)
    #  coemail                 :string(255)
    #  confirmdt               :date
    #  cooftelext              :string(255)
    #  cooftelno               :string(255)
    #  country_cd              :integer
    #  country_id              :integer
    #  created_at              :datetime
    #  employscheme            :string(255)
    #  employstatus            :integer
    #  fileno                  :string(255)
    #  gender                  :integer
    #  icno                    :string(255)
    #  id                      :integer          not null, primary key
    #  kwspcode                :string(255)
    #  mrtlstatuscd            :integer
    #  name                    :string(255)
    #  pension_confirm_date    :date
    #  pensiondt               :date
    #  pensionstat             :string(255)
    #  phonecell               :string(255)
    #  phonehome               :string(255)
    #  photo_content_type      :string(255)
    #  photo_file_name         :string(255)
    #  photo_file_size         :integer
    #  photo_updated_at        :datetime
    #  posconfirmdate          :date
    #  position_old            :integer
    #  poskod_id               :integer
    #  promotion_date          :date
    #  race                    :integer
    #  reconfirmation_date     :date
    #  religion                :integer
    #  schemedt                :date
    #  staff_shift_id          :integer
    #  staffgrade_id           :integer
    #  starting_salary         :decimal(, )
    #  statecd                 :integer
    #  svchead                 :string(255)
    #  svctype                 :string(255)
    #  taxcode                 :string(255)
    #  thumb_id                :integer
    #  time_group_id           :integer
    #  titlecd_id              :integer
    #  to_current_grade_date   :date
    #  transportclass_id       :string(255)
    #  uniformstat             :string(255)
    #  updated_at              :datetime
    #  wealth_decleration_date :date
