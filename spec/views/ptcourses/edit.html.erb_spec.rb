require 'rails_helper'

RSpec.describe "staff_training/ptcourses/edit", :type => :view do
  before(:each) do
    @admin_user=FactoryGirl.create(:admin_user)
    sign_in(@admin_user)
    @ptcourse = FactoryGirl.create(:ptcourse, approved: true, training_classification: 2, course_type: 7)
  end

  it "renders the edit ptcourse form" do
    render

    assert_select "h1", :text => @ptcourse.name
    
    #the FORM starts here
    assert_select "form[action=?][method=?]", staff_training_ptcourse_path(@ptcourse), "post" do
      
      assert_select "input#ptcourse_name[name=?]", "ptcourse[name]"
      #training_classification(2)=Learning Session (Confront)
      assert_select "select#ptcourse_training_classification[name=?]", "ptcourse[training_classification]"
      assert_select "input#ptcourse_level_1[name=?]", "ptcourse[level]"   
      assert_select "input#ptcourse_level_2[name=?]", "ptcourse[level]"
      #Learning Session (Confront) - related course_type: 7-12
      assert_select "input#ptcourse_course_type_7[name=?]", "ptcourse[course_type]"
      assert_select "input#ptcourse_course_type_8[name=?]", "ptcourse[course_type]"
      assert_select "input#ptcourse_course_type_9[name=?]", "ptcourse[course_type]"
      assert_select "input#ptcourse_course_type_10[name=?]", "ptcourse[course_type]"
      assert_select "input#ptcourse_course_type_11[name=?]", "ptcourse[course_type]"
      assert_select "input#ptcourse_course_type_12[name=?]", "ptcourse[course_type]"
      assert_select "select#ptcourse_provider_id[name=?]", "ptcourse[provider_id]"
      assert_select "select#ptcourse_duration_type[name=?]", "ptcourse[duration_type]"
      assert_select "textarea#ptcourse_description[name=?]", "ptcourse[description]"
      assert_select "input#ptcourse_cost[name=?]", "ptcourse[cost]"
      
      # buttons links
      assert_select "a[href=?]", staff_training_ptcourse_path(@ptcourse), {text: I18n.t("helpers.links.back")}
#       also works
#       assert_select "a.btn.btn-default>i.fa.fa-arrow-left"
      
      assert_select "input.btn.btn-primary[name=?][type=?][value=?]", "commit", "submit", I18n.t('update')
      
    end
    #the FORM ends here
    
  end
end