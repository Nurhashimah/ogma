require 'rails_helper'

RSpec.describe "staff_training/ptcourses/new", :type => :view do
  before(:each) do
    @admin_user=FactoryGirl.create(:admin_user)
    sign_in(@admin_user)
    @ptcourse = FactoryGirl.build(:ptcourse, approved: true)
  end

  it "renders new ptcourse form" do
    render

    assert_select "h1", :text => I18n.t('staff.training.course.new')
    
    #the FORM starts here
    assert_select "form[action=?][method=?]", staff_training_ptcourses_path, "post" do
      
      assert_select "input#ptcourse_name[name=?]", "ptcourse[name]"
      assert_select "select#ptcourse_training_classification[name=?]", "ptcourse[training_classification]"
      assert_select "input#ptcourse_level_1[name=?]", "ptcourse[level]"   
      assert_select "input#ptcourse_level_2[name=?]", "ptcourse[level]"
      assert_select "input#ptcourse_course_type_1[name=?]", "ptcourse[course_type]"
      assert_select "input#ptcourse_course_type_2[name=?]", "ptcourse[course_type]"
      assert_select "input#ptcourse_course_type_3[name=?]", "ptcourse[course_type]"
      assert_select "input#ptcourse_course_type_4[name=?]", "ptcourse[course_type]"
      assert_select "input#ptcourse_course_type_5[name=?]", "ptcourse[course_type]"
      assert_select "input#ptcourse_course_type_6[name=?]", "ptcourse[course_type]"
      assert_select "input#ptcourse_course_type_7[name=?]", "ptcourse[course_type]"
      assert_select "input#ptcourse_course_type_8[name=?]", "ptcourse[course_type]"
      assert_select "input#ptcourse_course_type_9[name=?]", "ptcourse[course_type]"
      assert_select "input#ptcourse_course_type_10[name=?]", "ptcourse[course_type]"
      assert_select "input#ptcourse_course_type_11[name=?]", "ptcourse[course_type]"
      assert_select "input#ptcourse_course_type_12[name=?]", "ptcourse[course_type]"
      assert_select "input#ptcourse_course_type_13[name=?]", "ptcourse[course_type]"
      assert_select "input#ptcourse_course_type_14[name=?]", "ptcourse[course_type]"
      assert_select "input#ptcourse_course_type_15[name=?]", "ptcourse[course_type]"
      assert_select "input#ptcourse_course_type_16[name=?]", "ptcourse[course_type]"
      assert_select "input#ptcourse_course_type_17[name=?]", "ptcourse[course_type]"
      assert_select "input#ptcourse_course_type_18[name=?]", "ptcourse[course_type]"
      assert_select "input#ptcourse_course_type_19[name=?]", "ptcourse[course_type]"
      assert_select "input#ptcourse_course_type_20[name=?]", "ptcourse[course_type]"
      assert_select "input#ptcourse_course_type_21[name=?]", "ptcourse[course_type]"
      assert_select "input#ptcourse_course_type_22[name=?]", "ptcourse[course_type]"
      assert_select "select#ptcourse_provider_id[name=?]", "ptcourse[provider_id]"
      assert_select "select#ptcourse_duration_type[name=?]", "ptcourse[duration_type]"
      assert_select "textarea#ptcourse_description[name=?]", "ptcourse[description]"
      assert_select "input#ptcourse_cost[name=?]", "ptcourse[cost]"
      
      # buttons links
      assert_select "a[href=?]", staff_training_ptcourses_path, {text: I18n.t("helpers.links.back")}
#       also works
#       assert_select "a.btn.btn-default>i.fa.fa-arrow-left"
      
      assert_select "input.btn.btn-primary[name=?][type=?][value=?]", "commit", "submit", I18n.t('create')
      
    end
    #the FORM ends here
    
  end
end