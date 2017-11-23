require 'rails_helper'

RSpec.describe "staff/instructor_appraisals/new", :type => :view do
  before(:each) do
    @admin_user=FactoryGirl.create(:admin_user)
    sign_in(@admin_user)
    assign(:instructor_appraisal, InstructorAppraisal.new(
      :staff_id => 1,
      :qc_sent => false,
      :appraisal_date => "2017-10-20",
      :q1 => 1,
      :q2 => 1,
      :q3 => 1,
      :q4 => 1,
      :q5 => 1,
      :q6 => 1,
      :q7 => 1,
      :q8 => 1,
      :q9 => 1,
      :q10 => 1,
      :q11 => 1,
      :q12 => 1,
      :q13 => 1,
      :q14 => 1,
      :q15 => 1,
      :q16 => 1,
      :q17 => 1,
      :q18 => 1,
      :q19 => 1,
      :q20 => 1,
      :q21 => 1,
      :q22 => 1,
      :q23 => 1,
      :q24 => 1,
      :q25 => 1,
      :q26 => 1,
      :q27 => 1,
      :q28 => 1,
      :q29 => 1,
      :q30 => 1,
      :q31 => 1,
      :q32 => 1,
      :q33 => 1,
      :q34 => 1,
      :q35 => 1,
      :q36 => 1,
      :q37 => 1,
      :q38 => 1,
      :q39 => 1,
      :q40 => 1,
      :q41 => 1,
      :q42 => 1,
      :q43 => 1,
      :q44 => 1,
      :q45 => 1,
      :q46 => 1,
      :q47 => 1,
      :q48 => 1,
      :total_mark => 1,
      :check_qc => 1,
      :checked => false
    ))
  end

  it "renders new instructor_appraisal form" do
    render

    assert_select "form[action=?][method=?]", staff_instructor_appraisals_path, "post" do

      assert_select "select#instructor_appraisal_staff_id[name=?]", "instructor_appraisal[staff_id]"

      assert_select "input#instructor_appraisal_qc_sent[name=?]", "instructor_appraisal[qc_sent]"
      
      assert_select "input#instructor_appraisal_appraisal_date[name=?]", "instructor_appraisal[appraisal_date]"

      assert_select "input#instructor_appraisal_q1_2[name=?]", "instructor_appraisal[q1]"
      assert_select "input#instructor_appraisal_q1_1[name=?]", "instructor_appraisal[q1]"
      assert_select "input#instructor_appraisal_q1_1[name=?]", "instructor_appraisal[q1]"

      assert_select "input#instructor_appraisal_q2_2[name=?]", "instructor_appraisal[q2]"
      assert_select "input#instructor_appraisal_q2_1[name=?]", "instructor_appraisal[q2]"
      assert_select "input#instructor_appraisal_q2_1[name=?]", "instructor_appraisal[q2]"

      assert_select "input#instructor_appraisal_q3_2[name=?]", "instructor_appraisal[q3]"
      assert_select "input#instructor_appraisal_q3_1[name=?]", "instructor_appraisal[q3]"
      assert_select "input#instructor_appraisal_q3_0[name=?]", "instructor_appraisal[q3]"

      assert_select "input#instructor_appraisal_q4_2[name=?]", "instructor_appraisal[q4]"
      assert_select "input#instructor_appraisal_q4_1[name=?]", "instructor_appraisal[q4]"
      assert_select "input#instructor_appraisal_q4_0[name=?]", "instructor_appraisal[q4]"

      assert_select "input#instructor_appraisal_q5_2[name=?]", "instructor_appraisal[q5]"
      assert_select "input#instructor_appraisal_q5_1[name=?]", "instructor_appraisal[q5]"
      assert_select "input#instructor_appraisal_q5_0[name=?]", "instructor_appraisal[q5]"

      assert_select "input#instructor_appraisal_q6_2[name=?]", "instructor_appraisal[q6]"
      assert_select "input#instructor_appraisal_q6_1[name=?]", "instructor_appraisal[q6]"
      assert_select "input#instructor_appraisal_q6_0[name=?]", "instructor_appraisal[q6]"

      assert_select "input#instructor_appraisal_q7_2[name=?]", "instructor_appraisal[q7]"
      assert_select "input#instructor_appraisal_q7_1[name=?]", "instructor_appraisal[q7]"
      assert_select "input#instructor_appraisal_q7_0[name=?]", "instructor_appraisal[q7]"

      assert_select "input#instructor_appraisal_q8_2[name=?]", "instructor_appraisal[q8]"
      assert_select "input#instructor_appraisal_q8_1[name=?]", "instructor_appraisal[q8]"
      assert_select "input#instructor_appraisal_q8_0[name=?]", "instructor_appraisal[q8]"

      assert_select "input#instructor_appraisal_q9_2[name=?]", "instructor_appraisal[q9]"
      assert_select "input#instructor_appraisal_q9_1[name=?]", "instructor_appraisal[q9]"
      assert_select "input#instructor_appraisal_q9_0[name=?]", "instructor_appraisal[q9]"

      assert_select "input#instructor_appraisal_q10_2[name=?]", "instructor_appraisal[q10]"
      assert_select "input#instructor_appraisal_q10_1[name=?]", "instructor_appraisal[q10]"
      assert_select "input#instructor_appraisal_q10_0[name=?]", "instructor_appraisal[q10]"
      
      assert_select "input#instructor_appraisal_q11_2[name=?]", "instructor_appraisal[q11]"
      assert_select "input#instructor_appraisal_q11_1[name=?]", "instructor_appraisal[q11]"
      assert_select "input#instructor_appraisal_q11_0[name=?]", "instructor_appraisal[q11]"

      assert_select "input#instructor_appraisal_q12_2[name=?]", "instructor_appraisal[q12]"
      assert_select "input#instructor_appraisal_q12_1[name=?]", "instructor_appraisal[q12]"
      assert_select "input#instructor_appraisal_q12_0[name=?]", "instructor_appraisal[q12]"

      assert_select "input#instructor_appraisal_q13_2[name=?]", "instructor_appraisal[q13]"
      assert_select "input#instructor_appraisal_q13_1[name=?]", "instructor_appraisal[q13]"
      assert_select "input#instructor_appraisal_q13_0[name=?]", "instructor_appraisal[q13]"

      assert_select "input#instructor_appraisal_q14_2[name=?]", "instructor_appraisal[q14]"
      assert_select "input#instructor_appraisal_q14_1[name=?]", "instructor_appraisal[q14]"
      assert_select "input#instructor_appraisal_q14_0[name=?]", "instructor_appraisal[q14]"

      assert_select "input#instructor_appraisal_q15_2[name=?]", "instructor_appraisal[q15]"
      assert_select "input#instructor_appraisal_q15_1[name=?]", "instructor_appraisal[q15]"
      assert_select "input#instructor_appraisal_q15_0[name=?]", "instructor_appraisal[q15]"

      assert_select "input#instructor_appraisal_q16_2[name=?]", "instructor_appraisal[q16]"
      assert_select "input#instructor_appraisal_q16_1[name=?]", "instructor_appraisal[q16]"
      assert_select "input#instructor_appraisal_q16_0[name=?]", "instructor_appraisal[q16]"

      assert_select "input#instructor_appraisal_q17_2[name=?]", "instructor_appraisal[q17]"
      assert_select "input#instructor_appraisal_q17_1[name=?]", "instructor_appraisal[q17]"
      assert_select "input#instructor_appraisal_q17_0[name=?]", "instructor_appraisal[q17]"

      assert_select "input#instructor_appraisal_q18_2[name=?]", "instructor_appraisal[q18]"
      assert_select "input#instructor_appraisal_q18_1[name=?]", "instructor_appraisal[q18]"
      assert_select "input#instructor_appraisal_q18_0[name=?]", "instructor_appraisal[q18]"

      assert_select "input#instructor_appraisal_q19_2[name=?]", "instructor_appraisal[q19]"
      assert_select "input#instructor_appraisal_q19_1[name=?]", "instructor_appraisal[q19]"
      assert_select "input#instructor_appraisal_q19_0[name=?]", "instructor_appraisal[q19]"

      assert_select "input#instructor_appraisal_q20_2[name=?]", "instructor_appraisal[q20]"
      assert_select "input#instructor_appraisal_q20_1[name=?]", "instructor_appraisal[q20]"
      assert_select "input#instructor_appraisal_q20_0[name=?]", "instructor_appraisal[q20]"

      assert_select "input#instructor_appraisal_q21_2[name=?]", "instructor_appraisal[q21]"
      assert_select "input#instructor_appraisal_q21_1[name=?]", "instructor_appraisal[q21]"
      assert_select "input#instructor_appraisal_q21_0[name=?]", "instructor_appraisal[q21]"

      assert_select "input#instructor_appraisal_q22_2[name=?]", "instructor_appraisal[q22]"
      assert_select "input#instructor_appraisal_q22_1[name=?]", "instructor_appraisal[q22]"
      assert_select "input#instructor_appraisal_q22_0[name=?]", "instructor_appraisal[q22]"

      assert_select "input#instructor_appraisal_q23_2[name=?]", "instructor_appraisal[q23]"
      assert_select "input#instructor_appraisal_q23_1[name=?]", "instructor_appraisal[q23]"
      assert_select "input#instructor_appraisal_q23_0[name=?]", "instructor_appraisal[q23]"

      assert_select "input#instructor_appraisal_q24_2[name=?]", "instructor_appraisal[q24]"
      assert_select "input#instructor_appraisal_q24_1[name=?]", "instructor_appraisal[q24]"
      assert_select "input#instructor_appraisal_q24_0[name=?]", "instructor_appraisal[q24]"

      assert_select "input#instructor_appraisal_q25_2[name=?]", "instructor_appraisal[q25]"
      assert_select "input#instructor_appraisal_q25_1[name=?]", "instructor_appraisal[q25]"
      assert_select "input#instructor_appraisal_q25_0[name=?]", "instructor_appraisal[q25]"

      assert_select "input#instructor_appraisal_q26_2[name=?]", "instructor_appraisal[q26]"
      assert_select "input#instructor_appraisal_q26_1[name=?]", "instructor_appraisal[q26]"
      assert_select "input#instructor_appraisal_q26_0[name=?]", "instructor_appraisal[q26]"

      assert_select "input#instructor_appraisal_q27_2[name=?]", "instructor_appraisal[q27]"
      assert_select "input#instructor_appraisal_q27_1[name=?]", "instructor_appraisal[q27]"
      assert_select "input#instructor_appraisal_q27_0[name=?]", "instructor_appraisal[q27]"

      assert_select "input#instructor_appraisal_q28_2[name=?]", "instructor_appraisal[q28]"
      assert_select "input#instructor_appraisal_q28_1[name=?]", "instructor_appraisal[q28]"
      assert_select "input#instructor_appraisal_q28_0[name=?]", "instructor_appraisal[q28]"

      assert_select "input#instructor_appraisal_q29_2[name=?]", "instructor_appraisal[q29]"
      assert_select "input#instructor_appraisal_q29_1[name=?]", "instructor_appraisal[q29]"
      assert_select "input#instructor_appraisal_q29_0[name=?]", "instructor_appraisal[q29]"

      assert_select "input#instructor_appraisal_q30_2[name=?]", "instructor_appraisal[q30]"
      assert_select "input#instructor_appraisal_q30_1[name=?]", "instructor_appraisal[q30]"
      assert_select "input#instructor_appraisal_q30_0[name=?]", "instructor_appraisal[q30]"

      assert_select "input#instructor_appraisal_q31_2[name=?]", "instructor_appraisal[q31]"
      assert_select "input#instructor_appraisal_q31_1[name=?]", "instructor_appraisal[q31]"
      assert_select "input#instructor_appraisal_q31_0[name=?]", "instructor_appraisal[q31]"

      assert_select "input#instructor_appraisal_q32_2[name=?]", "instructor_appraisal[q32]"
      assert_select "input#instructor_appraisal_q32_1[name=?]", "instructor_appraisal[q32]"
      assert_select "input#instructor_appraisal_q32_0[name=?]", "instructor_appraisal[q32]"

      assert_select "input#instructor_appraisal_q33_2[name=?]", "instructor_appraisal[q33]"
      assert_select "input#instructor_appraisal_q33_1[name=?]", "instructor_appraisal[q33]"
      assert_select "input#instructor_appraisal_q33_0[name=?]", "instructor_appraisal[q33]"

      assert_select "input#instructor_appraisal_q34_2[name=?]", "instructor_appraisal[q34]"
      assert_select "input#instructor_appraisal_q34_1[name=?]", "instructor_appraisal[q34]"
      assert_select "input#instructor_appraisal_q34_0[name=?]", "instructor_appraisal[q34]"

      assert_select "input#instructor_appraisal_q35_2[name=?]", "instructor_appraisal[q35]"
      assert_select "input#instructor_appraisal_q35_1[name=?]", "instructor_appraisal[q35]"
      assert_select "input#instructor_appraisal_q35_0[name=?]", "instructor_appraisal[q35]"

      assert_select "input#instructor_appraisal_q36_2[name=?]", "instructor_appraisal[q36]"
      assert_select "input#instructor_appraisal_q36_1[name=?]", "instructor_appraisal[q36]"
      assert_select "input#instructor_appraisal_q36_0[name=?]", "instructor_appraisal[q36]"

      assert_select "input#instructor_appraisal_q37_2[name=?]", "instructor_appraisal[q37]"
      assert_select "input#instructor_appraisal_q37_1[name=?]", "instructor_appraisal[q37]"
      assert_select "input#instructor_appraisal_q37_0[name=?]", "instructor_appraisal[q37]"

      assert_select "input#instructor_appraisal_q38_2[name=?]", "instructor_appraisal[q38]"
      assert_select "input#instructor_appraisal_q38_1[name=?]", "instructor_appraisal[q38]"
      assert_select "input#instructor_appraisal_q38_0[name=?]", "instructor_appraisal[q38]"

      assert_select "input#instructor_appraisal_q39_2[name=?]", "instructor_appraisal[q39]"
      assert_select "input#instructor_appraisal_q39_1[name=?]", "instructor_appraisal[q39]"
      assert_select "input#instructor_appraisal_q39_0[name=?]", "instructor_appraisal[q39]"

      assert_select "input#instructor_appraisal_q40_2[name=?]", "instructor_appraisal[q40]"
      assert_select "input#instructor_appraisal_q40_1[name=?]", "instructor_appraisal[q40]"
      assert_select "input#instructor_appraisal_q40_0[name=?]", "instructor_appraisal[q40]"

      assert_select "input#instructor_appraisal_q41_2[name=?]", "instructor_appraisal[q41]"
      assert_select "input#instructor_appraisal_q41_1[name=?]", "instructor_appraisal[q41]"
      assert_select "input#instructor_appraisal_q41_0[name=?]", "instructor_appraisal[q41]"

      assert_select "input#instructor_appraisal_q42_2[name=?]", "instructor_appraisal[q42]"
      assert_select "input#instructor_appraisal_q42_1[name=?]", "instructor_appraisal[q42]"
      assert_select "input#instructor_appraisal_q42_0[name=?]", "instructor_appraisal[q42]"

      assert_select "input#instructor_appraisal_q43_2[name=?]", "instructor_appraisal[q43]"
      assert_select "input#instructor_appraisal_q43_1[name=?]", "instructor_appraisal[q43]"
      assert_select "input#instructor_appraisal_q43_0[name=?]", "instructor_appraisal[q43]"

      assert_select "input#instructor_appraisal_q44_2[name=?]", "instructor_appraisal[q44]"
      assert_select "input#instructor_appraisal_q44_1[name=?]", "instructor_appraisal[q44]"
      assert_select "input#instructor_appraisal_q44_0[name=?]", "instructor_appraisal[q44]"

      assert_select "input#instructor_appraisal_q45_2[name=?]", "instructor_appraisal[q45]"
      assert_select "input#instructor_appraisal_q45_1[name=?]", "instructor_appraisal[q45]"
      assert_select "input#instructor_appraisal_q45_0[name=?]", "instructor_appraisal[q45]"

      assert_select "input#instructor_appraisal_q46_2[name=?]", "instructor_appraisal[q46]"
      assert_select "input#instructor_appraisal_q46_1[name=?]", "instructor_appraisal[q46]"
      assert_select "input#instructor_appraisal_q46_0[name=?]", "instructor_appraisal[q46]"

      assert_select "input#instructor_appraisal_q47_2[name=?]", "instructor_appraisal[q47]"
      assert_select "input#instructor_appraisal_q47_1[name=?]", "instructor_appraisal[q47]"
      assert_select "input#instructor_appraisal_q47_0[name=?]", "instructor_appraisal[q47]"

      assert_select "input#instructor_appraisal_q48_2[name=?]", "instructor_appraisal[q48]"
      assert_select "input#instructor_appraisal_q48_1[name=?]", "instructor_appraisal[q48]"
      assert_select "input#instructor_appraisal_q48_0[name=?]", "instructor_appraisal[q48]"

#       assert_select "input#instructor_appraisal_total_mark[name=?]", "instructor_appraisal[total_mark]"

      assert_select "select#instructor_appraisal_check_qc[name=?]", "instructor_appraisal[check_qc]"

#       assert_select "input#instructor_appraisal_checked[name=?]", "instructor_appraisal[checked]"
    end
  end
end
