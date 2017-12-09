require 'rails_helper'

RSpec.describe "training/programmes/show", :type => :view do
  before(:each) do
    @admin_user=FactoryGirl.create(:admin_user)
    sign_in(@admin_user)
    @root = FactoryGirl.create(:programme)
    @module = FactoryGirl.create(:module, parent: @root)
    @subject = FactoryGirl.create(:subject, parent: @module)
    @programme = FactoryGirl.create(:topic, parent: @subject, lecture_d: "00:15:00", tutorial_d: "00:30:00", practical_d: "00:45:00", duration: 1.5, durationtype: "hours")
  end

  it "renders attributes in <dl>" do
    render
    
    assert_select "h1", :text => "#{@programme.course_type}: #{@programme.name}"
      
    assert_select "dl>dt", :text => I18n.t('training.programme.code')
    assert_select "dd", :text => @programme.combo_code
    assert_select "dt", :text => I18n.t('training.programme.course_type')
    assert_select "dd", :text => I18n.t('training.programme.topic')
    assert_select "dl>dt", :text => I18n.t('training.programme.method')
    expect(rendered).to match("(\n<strong>Lecture : </strong>\n 15 Min\n/\n<strong>Tutorial : </strong>\n 30 Min\n/\n<strong>Practical : </strong>\n 45 Min\n)")
    
#        +(
#        +<strong>Lecture : </strong>
#        + 15 Min
#        +/
#        +<strong>Tutorial : </strong>
#        + 30 Min
#        +/
#        +<strong>Practical : </strong>
#        + 45 Min
#        +)
    
    assert_select "dt", :text => I18n.t('training.programme.name')
    assert_select "dd", :text => @programme.name
    
    assert_select "dt", :text => I18n.t('training.programme.subject_abbreviation')
    assert_select "dd", :text => @programme.subject_abbreviation
    
    assert_select "dt", :text => I18n.t('training.programme.credits')
    assert_select "dd", :text => @programme.credits
    
    assert_select "dt", :text => I18n.t('training.programme.status')
    assert_select "dd", :text => (DropDown::COURSE_STATUS.find_all{|disp, value| value == @programme.status}).map {|disp, value| disp} [0]
    
    assert_select "dt", :text => I18n.t('training.programme.duration')
    expect(rendered).to match("#{@programme.duration}\n#{(DropDown::DURATIONTYPES.find_all{|disp, value| value == @programme.durationtype}).map {|disp, value| disp}[0]}")
    
    #page - buttons / links
    assert_select "a[href=?]", training_programmes_path, {text: "#{I18n.t("helpers.links.back")}" }
    assert_select "a[href=?]", edit_training_programme_path(@programme), {text: I18n.t("helpers.links.edit")}
    assert_select "a[href=?]", training_programme_path(@programme), {text: I18n.t("helpers.links.destroy")}
   
  end
end

  