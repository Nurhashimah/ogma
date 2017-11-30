require 'rails_helper'

RSpec.describe "exam/exam_templates/index", :type => :view do
  before(:each) do
    @staff_user=FactoryGirl.create(:staff_user)
    sign_in(@staff_user)
    @exam_template1=FactoryGirl.create(:exam_template, created_by: @staff_user.id)
    @exam_template2=FactoryGirl.create(:exam_template, created_by: @staff_user.id)
    @search=ExamTemplate.search(params[:q])
    @exam_templates=@search.result.page(params[:page]).per(5)
  end

  it "renders a list of exam_templates" do
    render
#     puts "#{@exam_template1.try(:creator).try(:userable).try(:staff_with_rank)}"
    assert_select "h1", :text => I18n.t('exam.exam_template.title'), :count => 1
    assert_select "tr>td", :text => @exam_template1.name, :count => 1
    assert_select "tr>td", :text => @exam_template2.name, :count => 1
    assert_select "td", :text => @exam_template1.try(:creator).try(:userable).try(:staff_with_rank).strip, :count => 2
    assert_select "td.centre", :text => "2\n / \n40\n%\n / \n2".html_safe,  :count => 2
  end
end
