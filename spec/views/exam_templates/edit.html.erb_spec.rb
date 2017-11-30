require 'rails_helper'

RSpec.describe "exam/exam_templates/edit", :type => :view do
  before(:each) do
    @staff_user=FactoryGirl.create(:staff_user)
    sign_in(@staff_user)
    @exam_template=FactoryGirl.create(:exam_template)
  end

  it "renders the edit exam_template form" do
    render

    assert_select "form[action=?][method=?]", exam_exam_template_path(@exam_template), "post" do

      assert_select "input#exam_template_name[name=?]", "exam_template[name]"

      assert_select "input#exam_template_created_by[name=?][type=?]", "exam_template[created_by]", "hidden"
      
#       TODO - fix below-30Nov2017
#       assert_select "input#exam_template_question_count_mcq[count][name=?]", "exam_template[question_count][mcq[count]]"
#       
#       assert_select "input#exam_template_question_count_mcq[weight][name=?]", "exam_template[question_count][mcq[weight]]"
#       
#       assert_select "input#exam_template_question_count_mcq[full_marks][name=?]", "exam_template[question_count][mcq[full_marks]]"

#       assert_select "input#exam_template_data[name=?]", "exam_template[data]"
    end
  end
end
