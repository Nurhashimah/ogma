FactoryGirl.define do
  sequence :email do |n|
    "person#{n}@example.com"
  end
end

FactoryGirl.define do
  factory :admin_user, :class => 'User' do
    email
    password '12345678'
    password_confirmation '12345678'
    association :college, factory: :college
    userable factory: :basic_staff_with_position  #polymorphic (userable_type & userable_id)
    after(:create) {|user| user.roles = [create(:admin_role)]}
#     after(:create) {|user| user.roles = [create(:staff_role)]}
    after(:create) {|user| user.roles = [create(:student_discipline_module_admin)]}
    after(:create) {|user| user.roles = [create(:training_budget_module_admin)]}
    after(:create) {|user| user.roles = [create(:training_courses_module_admin)]}
    after(:create) {|user| user.roles = [create(:training_schedule_module_admin)]}
    after(:create) {|user| user.roles = [create(:training_attendance_module_admin)]}
    after(:create) {|user| user.roles = [create(:tenants_module_admin)]}
    after(:create) {|user| user.roles = [create(:locations_module_admin)]}
    after(:create) {|user| user.roles = [create(:location_damages_module_admin)]}
    after(:create) {|user| user.roles = [create(:bookingfacilities_module_admin)]}
    after(:create) {|user| user.roles = [create(:staffs_module_admin)]}
    after(:create) {|user| user.roles = [create(:positions_module_admin)]}
    after(:create) {|user| user.roles = [create(:staff_appraisals_module_admin)]}
    after(:create) {|user| user.roles = [create(:staff_leaves_module_admin)]}
    after(:create) {|user| user.roles = [create(:travel_claims_module_admin)]}
    after(:create) {|user| user.roles = [create(:travel_requests_module_admin)]}
    after(:create) {|user| user.roles = [create(:stationeries_module_admin)]}
    after(:create) {|user| user.roles = [create(:asset_losses_module_admin)]}
    after(:create) {|user| user.roles = [create(:asset_loans_module_admin)]}
    after(:create) {|user| user.roles = [create(:asset_disposals_module_admin)]}
    after(:create) {|user| user.roles = [create(:asset_defect_module_admin)]}
    after(:create) {|user| user.roles = [create(:asset_list_module_admin)]}
    after(:create) {|user| user.roles = [create(:student_intake_module_admin)]}
    
    after(:create) {|user| user.roles = [create(:instructor_appraisals_module_admin)]}
    after(:create) {|user| user.roles = [create(:average_instructors_module_admin)]}
    
    after(:create) {|user| user.roles = [create(:staff_ranks_module_admin)]}
    after(:create) {|user| user.roles = [create(:staff_employgrades_module_admin)]}
    after(:create) {|user| user.roles = [create(:staff_postinfos_module_admin)]}
  end

  factory :staff_user, :class => 'User' do
    sequence(:email) { |n| "slatest#{n}@example.com" }
    sequence(:login) { |n| "slatest#{n}@example.com" }
    password '12345678'
    password_confirmation '12345678'
    association :college, factory: :college
    #ref https://robots.thoughtbot.com/aint-no-calla-back-girl
    userable factory: :basic_staff_with_position  #polymorphic (userable_type & userable_id)
    after(:create) {|user| user.roles = [create(:staff_role)]}
  end
  
  factory :admin_role, :class => 'Role' do
    name 'Administration'
    authname 'administration'
  end

  factory :staff_role, :class => 'Role' do
    name 'Staff'
    authname 'staff'
  end
  
  factory :student_discipline_module_admin, :class => 'Role' do
    name 'Student Discipline Module Admin'
    authname 'student_discipline_module_admin'
  end
  
  factory :training_budget_module_admin, :class => 'Role' do
    name 'Training Budget Module Admin'
    authname 'training_budget_module_admin'
  end
  
  factory :training_courses_module_admin, :class => 'Role' do
    name 'Training Courses Module Admin'
    authname 'training_courses_module_admin'
  end
  
  factory :training_schedule_module_admin, :class => 'Role' do
    name 'Training Schedule Module Admin'
    authname 'training_schedule_module_admin'
  end
  
  factory :training_attendance_module_admin, :class => 'Role' do
    name 'Training Attendance Module Admin'
    authname 'training_attendance_module_admin'
  end
  
  factory :tenants_module_admin, :class => 'Role' do
    name 'Tenants Module Admin'
    authname 'tenants_module_admin'
  end
  
   factory :locations_module_admin, :class => 'Role' do
    name 'Locations Module Admin'
    authname 'locations_module_admin'
  end
  
  factory :location_damages_module_admin, :class => 'Role' do
    name 'Location Damages Module Admin'
    authname 'location_damages_module_admin'
  end
  
  factory :bookingfacilities_module_admin, :class => 'Role' do
    name 'Bookingfacilities Module Admin'
    authname 'bookingfacilities_module_admin'
  end
  
  factory :staffs_module_admin, :class => 'Role' do
    name 'Staffs Module Admin'
    authname 'staffs_module_admin'
  end
  
  factory :positions_module_admin, :class => 'Role' do
    name 'Positions Module Admin'
    authname 'positions_module_admin'
  end
  
  factory :staff_attendances_module_admin, :class => 'Role' do
    name 'Staff Attendances Module Admin'
    authname 'staff_attendances_module_admin'
  end
  
  factory :fingerprints_module_admin, :class => 'Role' do
    name 'Fingerprints Module Admin'
    authname 'fingerprints_module_admin'
  end
  
  factory :staff_appraisals_module_admin, :class => 'Role' do
    name 'Staff Appraisals Module  Admin'
    authname 'staff_appraisals_module_admin'
  end
  
  factory :staff_leaves_module_admin, :class => 'Role' do
    name 'Staff Leaves Module Admin'
    authname 'staff_leaves_module_admin'
  end
  
  factory :travel_claims_module_admin, :class => 'Role' do
    name 'Travel Claims Module Admin'
    authname 'travel_claims_module_admin'
  end
  
  factory :travel_requests_module_admin, :class => 'Role' do
    name 'Travel Requests Module Admin'
    authname 'travel_requests_module_admin'
  end
  
  factory :stationeries_module_admin, :class => 'Role' do
    name 'Stationeries Module Admin'
    authname 'stationeries_module_admin'
  end
  
  factory :asset_losses_module_admin, :class => 'Role' do
    name 'Asset Losses Module Admin'
    authname 'asset_losses_module_admin'
  end
  
  factory :asset_loans_module_admin, :class => 'Role' do
    name 'Asset Loans Module Admin'
    authname 'asset_loans_module_admin'
  end
  
  factory :asset_disposals_module_admin, :class => 'Role' do
    name 'Asset Disposals Module Admin'
    authname 'asset_disposals_module_admin'
  end
  
  factory :asset_defect_module_admin, :class => 'Role' do
    name 'Asset Defect Module Admin'
    authname 'asset_defect_module_admin'
  end
  
  factory :asset_list_module_admin, :class => 'Role' do
    name 'Asset List Module Admin'
    authname 'asset_list_module_admin'
  end
  
  factory :student_intake_module_admin, :class => 'Role' do
    name 'Student Intake Module Admin'
    authname 'student_intake_module_admin'
  end
  
  factory :instructor_appraisals_module_admin, :class => 'Role' do
    name 'Instructor Appraisals Module Admin'
    authname 'instructor_appraisals_module_admin'
  end
  
  factory :average_instructors_module_admin, :class => 'Role' do
    name 'Average Instructors Module Admin'
    authname 'instructor_appraisals_module_admin'
  end
  
  factory :staff_ranks_module_admin, :class => 'Role' do
    name 'Staff Ranks Module Admin'
    authname 'staff_ranks_module_admin'
  end
  
  factory :staff_employgrades_module_admin, :class => 'Role' do
    name 'Staff Employgrades Module Admin'
    authname 'staff_employgrades_module_admin'
  end
  
  factory :staff_postinfos_module_admin, :class => 'Role' do
    name 'Staff Postinfos Module Admin'
    authname 'staff_postinfos_module_admin'
  end

end
