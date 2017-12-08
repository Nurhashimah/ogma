require 'rails_helper'

RSpec.describe "staff_training/ptcourses/show", :type => :view do
  before(:each) do
    @admin_user=FactoryGirl.create(:admin_user)
    sign_in(@admin_user)
    @ptcourse = FactoryGirl.create(:ptcourse, approved: true, description: "Course description - longer one is here. longer one is here. longer one is here. longer one is here. longer one is here. longer one is here")
  end

  it "renders attributes in <dl>" do
    render
    
    assert_select "h1", :text => @ptcourse.name
      
    assert_select "dl>dt", :text => I18n.t('staff.training.course.name')
    assert_select "dd", :text => @ptcourse.name
    assert_select "dl>dt", :text => I18n.t('staff.training.course.training_classification')
    assert_select "dd", :text => (DropDown::PROGRAMME_CLASSIFICATION.find_all{|disp, value| value == @ptcourse.training_classification}).map {|disp, value| disp}[0]
    assert_select "dl>dt", :text => I18n.t('staff.training.course.level')
    assert_select "dd", :text => (DropDown::TRAINING_LEVEL.find_all{|disp, value| value == @ptcourse.level}).map {|disp, value| disp}[0]
    assert_select "dl>dt", :text => I18n.t('staff.training.course.course_type')
    assert_select "dd", :text => (DropDown::STAFF_COURSE_TYPE.find_all{|disp, value| value == @ptcourse.course_type}).map {|disp, value| disp}[0]
    assert_select "dl>dt", :text => I18n.t('staff.training.course.provider')
    assert_select "dd", :text => @ptcourse.provider.try(:name)
    assert_select "dl>dt", :text => I18n.t('staff.training.course.duration')
    expect(rendered).to match("#{number_with_precision(@ptcourse.duration, precision: 0)}")
    expect(rendered).to match("#{(DropDown::DURATION_TYPE.find_all{|disp, value| value == @ptcourse.duration_type}).map {|disp, value| disp}[0]}")
    assert_select "dl>dt", :text => I18n.t('staff.training.course.description')
    assert_select "dd", :text => @ptcourse.description
    assert_select "dl>dt", :text => I18n.t('staff.training.course.costs')
    assert_select "dd", :text => ringgols(@ptcourse.cost)
    assert_select "dl>dt", :text => I18n.t('staff.training.course.status')
    assert_select "dd", :text => I18n.t('approved')
    
    #page - buttons / links
    assert_select "a[href=?]", staff_training_ptcourses_path, {text: "#{I18n.t("helpers.links.back")}" }
    assert_select "a[href=?]", new_staff_training_ptschedule_path(:ptcourse_id => @ptcourse)
    assert_select "a[href=?]", edit_staff_training_ptcourse_path(@ptcourse), {text: I18n.t("helpers.links.edit")}
    assert_select "a[href=?]", staff_training_ptcourse_path(@ptcourse), {text: I18n.t("helpers.links.destroy")}
   
  end
end

  