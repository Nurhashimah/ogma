require 'rails_helper'

RSpec.describe "exam/exams/index", :type => :view do
  before(:each) do
    @admin_user=FactoryGirl.create(:admin_user)
    sign_in(@admin_user)
    @basic_staff=FactoryGirl.create(:basic_staff)
    @module=FactoryGirl.create(:module)
    @programme_id=@module.root_id
    @subject1=FactoryGirl.create(:subject, code: "01", parent_id: @module.id)
    @subject2=FactoryGirl.create(:subject, code: "02", parent_id: @module.id)
    @exam1=FactoryGirl.create(:exam, subject_id: @subject1.id, exam_on: "2017-12-01", starttime: "08:00:00",endtime: "10:00:00", created_by: @basic_staff.id)
    @exam2=FactoryGirl.create(:exam, subject_id: @subject2.id, exam_on: "2017-12-01", starttime: "08:00:00",endtime: "10:00:00", created_by: @basic_staff.id)
    @search = Exam.order(subject_id: :asc, exam_on: :desc).search(params[:q])
    @exams = @search.result.search2(@programme_id)
    @exams = @exams.page(params[:page]||1)
    @programme_exams = @exams.group_by{|x|x.subject.root}
  end

  it "renders a list of exams" do 
    
    render
    
    #puts "#{@exam2.duration_in_str} ~~ #{@programme_exams[@module.root][0].duration_in_str}" 
    
    assert_select "h1", :text => I18n.t('exam.exams.title')
    assert_select "tr>td>a", :text => "#{@programme_exams[@module.root][0].render_examtype[0]}", :count => 2
    assert_select "tr>td", :text =>"#{@module.root.try(:programme_list)}" , :count => 2
    assert_select "tr>td", :text => "01 Dec 2017", :count => 2
    assert_select "tr>td", :text => "08:00 - 10:00", :count => 2
    assert_select "tr>td", :text => @basic_staff.name, :count => 2
    assert_select "tr>td", :text => "2 hours", :count => 2
    assert_select "tr>td", :text => @exam1.total_marks, :count => 2
    
    expect(rendered).to match(@subject1.try(:subject_list))
    expect(rendered).to match("(#{I18n.t('training.programme.module')} : #{@module.subject_list})")
  end
  
end
