require 'rails_helper'

RSpec.describe "training/programmes/index", :type => :view do
  
  before(:each) do
    @admin_user=FactoryGirl.create(:admin_user)
    sign_in(@admin_user)
    @programme = FactoryGirl.create(:programme)
    @module = FactoryGirl.create(:module, parent: @programme)
    @subject = FactoryGirl.create(:subject, parent: @module)
    @topic = FactoryGirl.create(:topic, parent: @subject, lecture_d: "00:15:00", tutorial_d: "00:30:00", practical_d: "00:45:00")
    @subtopic = FactoryGirl.create(:subtopic, parent: @topic, lecture_d: "00:15:00", tutorial_d: "00:30:00", practical_d: "00:45:00") 
    @programmes=Programme.all
  end

  it "renders a list of programmes" do
    render

    assert_select "h1", :text => I18n.t('training.programme.title')
    
    assert_select "a[href=?]", new_training_programme_path, :text => I18n.t('training.programme.new_programme')
    assert_select "a[href=?]", programme_report_training_programmes_path(params.merge(format: 'pdf' )), :text => I18n.t('actions.print'), :count => 1
    
    #headers
    assert_select "span.combo_code", :text => I18n.t('training.programme.combo_code_amsas')
    assert_select "span.credits", :text => I18n.t('training.programme.credits')
    assert_select "span.duration", :text => I18n.t('training.programme.duration')
    assert_select "span.lecture", :text => I18n.t('training.programme.lecture')
    assert_select "span.tutorial", :text => I18n.t('training.programme.tutorial')
    assert_select "span.practical", :text => I18n.t('training.programme.practical')

    #programme
    assert_select "strong", :text => @programme.code
    assert_select "a[href=?]", training_programme_path(@programme), :text => @programme.programme_list
    assert_select "span.credits", :text => @programme.credits
    assert_select "span.status", :text =>  check_kin_blank {(DropDown::COURSE_STATUS.find_all{|disp, value| value == @programme.status}).map {|disp, value| disp} }[0]
    assert_select "span.duration", :text => @programme.try(:total_duration)
    
    #module
    assert_select "strong", :text => @module.code
    assert_select "a[href=?]", training_programme_path(@module), :text => @module.name
    assert_select "span.credits", :text => @module.credits
    assert_select "span.status", :text =>  check_kin_blank {(DropDown::COURSE_STATUS.find_all{|disp, value| value == @module.status}).map {|disp, value| disp} }[0]
    assert_select "span.duration", :text => @module.try(:total_duration)
    
    #programme & module, note for subject lines: blank fields
    assert_select "span.lecture", :text => "-", :count => 2
    assert_select "span.tutorial", :text => "-", :count => 2
    assert_select "span.practical", :text => "-", :count => 2
    
    #subject
    assert_select "strong", :text => @subject.code
    assert_select "a[href=?]", training_programme_path(@subject), :text => @subject.name
    assert_select "span.credits", :text => @subject.credits
    assert_select "span.status", :text =>  check_kin_blank {(DropDown::COURSE_STATUS.find_all{|disp, value| value == @subject.status}).map {|disp, value| disp} }[0]
    assert_select "span.duration", :text => @subject.try(:total_duration)
    
    #topic
    assert_select "strong", :text => @topic.code
    assert_select "a[href=?]", training_programme_path(@topic), :text => @topic.name
    assert_select "span.credits", :text => @topic.credits
    assert_select "span.status", :text =>  check_kin_blank {(DropDown::COURSE_STATUS.find_all{|disp, value| value == @topic.status}).map {|disp, value| disp} }[0]
    assert_select "span.duration", :text => @topic.try(:total_duration)
    
    #subtopic
    assert_select "strong", :text => @subtopic.code
    assert_select "a[href=?]", training_programme_path(@subtopic), :text => @subtopic.name
    assert_select "span.credits", :text => @subtopic.credits
    assert_select "span.status", :text =>  check_kin_blank {(DropDown::COURSE_STATUS.find_all{|disp, value| value == @subtopic.status}).map {|disp, value| disp} }[0]
    assert_select "span.duration", :text => @subtopic.try(:total_duration)
    
    #topic & subtopic
    assert_select "span.lecture", :text => @topic.lecture_duration.strip, :count => 2
    assert_select "span.tutorial", :text => @topic.tutorial_duration.strip, :count => 2
    assert_select "span.practical", :text => @topic.practical_duration.strip, :count => 2

  end
end