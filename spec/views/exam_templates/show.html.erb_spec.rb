require 'rails_helper'

RSpec.describe "exam/exam_templates/show", :type => :view do
  before(:each) do
    @staff_user=FactoryGirl.create(:staff_user)
    sign_in(@staff_user)
    @exam_template=FactoryGirl.create(:exam_template, name: "Template 1")
  end

  it "renders attributes in <dl>" do
    render
    expect(rendered).to match(/Template 1/)
    expect(rendered).to match("#{@exam_template.creator.userable.staff_with_rank.strip}")
    expect(rendered).to match("MCQ : \n2\n questions, weighted at 40\n, full marks : 2".html_safe)
  end
end