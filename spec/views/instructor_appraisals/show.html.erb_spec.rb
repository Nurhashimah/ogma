require 'rails_helper'

RSpec.describe "staff/instructor_appraisals/show", :type => :view do
  before(:each) do
    @instructor_appraisal=FactoryGirl.create(:instructor_appraisal, appraisal_date: "2017-10-20", qc_sent: false, checked: nil, total_mark: 0)
    
#     @basic_staff_with_rank1=FactoryGirl.create(:basic_staff_with_rank)
#     @basic_staff_with_rank2=FactoryGirl.create(:basic_staff_with_rank)
#     @instructor_appraisal = assign(:instructor_appraisal, InstructorAppraisal.create!(
#       :staff_id => @basic_staff_with_rank1.id,
#       :qc_sent => false,
#       :appraisal_date => "2017-10-20",
#       :q1 => 1,
#       :q2 => 1,
#       :q3 => 1,
#       :q4 => 1,
#       :q5 => 1,
#       :q6 => 1,
#       :q7 => 1,
#       :q8 => 1,
#       :q9 => 1,
#       :q10 => 1,
#       :q11 => 1,
#       :q12 => 1,
#       :q13 => 1,
#       :q14 => 1,
#       :q15 => 1,
#       :q16 => 1,
#       :q17 => 1,
#       :q18 => 1,
#       :q19 => 1,
#       :q20 => 1,
#       :q21 => 1,
#       :q22 => 1,
#       :q23 => 1,
#       :q24 => 1,
#       :q25 => 1,
#       :q26 => 1,
#       :q27 => 1,
#       :q28 => 1,
#       :q29 => 1,
#       :q30 => 1,
#       :q31 => 1,
#       :q32 => 1,
#       :q33 => 1,
#       :q34 => 1,
#       :q35 => 1,
#       :q36 => 1,
#       :q37 => 1,
#       :q38 => 1,
#       :q39 => 1,
#       :q40 => 1,
#       :q41 => 1,
#       :q42 => 1,
#       :q43 => 1,
#       :q44 => 1,
#       :q45 => 1,
#       :q46 => 1,
#       :q47 => 1,
#       :q48 => 1,
#       :total_mark => 48,
#       :check_qc => @basic_staff_with_rank2.id,
#       :checked => false
#     ))
  end

  it "renders attributes in <p>" do
    render
    
    assert_select "dd", :text => "#{@instructor_appraisal.instructor.staff_with_rank}", :count => 1
    assert_select "dd", :text => "#{@instructor_appraisal.checker.staff_with_rank}", :count => 1
    assert_select "dd>i.fa.fa-times", 2     #qc_sent, checked(display X for nil value)
    expect(rendered).to match(/20-10-2017/)
    expect(rendered).to match(/0/)         #total_mark
    
#     expect(rendered).to match(/1/)
#     expect(rendered).to match(/false/)
    
#     expect(rendered).to match(/2/)
#     expect(rendered).to match(/3/)
#     expect(rendered).to match(/4/)
#     expect(rendered).to match(/5/)
#     expect(rendered).to match(/6/)
#     expect(rendered).to match(/7/)
#     expect(rendered).to match(/8/)
#     expect(rendered).to match(/9/)
#     expect(rendered).to match(/10/)
#     expect(rendered).to match(/11/)
#     expect(rendered).to match(/12/)
#     expect(rendered).to match(/13/)
#     expect(rendered).to match(/14/)
#     expect(rendered).to match(/15/)
#     expect(rendered).to match(/16/)
#     expect(rendered).to match(/17/)
#     expect(rendered).to match(/18/)
#     expect(rendered).to match(/19/)
#     expect(rendered).to match(/20/)
#     expect(rendered).to match(/21/)
#     expect(rendered).to match(/22/)
#     expect(rendered).to match(/23/)
#     expect(rendered).to match(/24/)
#     expect(rendered).to match(/25/)
#     expect(rendered).to match(/26/)
#     expect(rendered).to match(/27/)
#     expect(rendered).to match(/28/)
#     expect(rendered).to match(/29/)
#     expect(rendered).to match(/30/)
#     expect(rendered).to match(/31/)
#     expect(rendered).to match(/32/)
#     expect(rendered).to match(/33/)
#     expect(rendered).to match(/34/)
#     expect(rendered).to match(/35/)
#     expect(rendered).to match(/36/)
#     expect(rendered).to match(/37/)
#     expect(rendered).to match(/38/)
#     expect(rendered).to match(/39/)
#     expect(rendered).to match(/40/)
#     expect(rendered).to match(/41/)
#     expect(rendered).to match(/42/)
#     expect(rendered).to match(/43/)
#     expect(rendered).to match(/44/)
#     expect(rendered).to match(/45/)
#     expect(rendered).to match(/46/)
#     expect(rendered).to match(/47/)
#     expect(rendered).to match(/48/)
#     expect(rendered).to match(/49/)
#     expect(rendered).to match(/50/)
#     expect(rendered).to match(/51/)
#     expect(rendered).to match(/false/)
  end
end
