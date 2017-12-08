require 'rails_helper'

RSpec.describe "staff_training/ptcourses/index", :type => :view do
  
  before(:each) do
    @admin_user=FactoryGirl.create(:admin_user)
    sign_in(@admin_user)
    @ptcourse1 = FactoryGirl.create(:ptcourse, approved: true, description: "Course description - longer one is here. longer one is here. longer one is here. longer one is here. longer one is here. longer one is here")
    @ptcourse2 = FactoryGirl.create(:ptcourse, approved: false)
    @search=Ptcourse.search(params[:q])
    @ptcourses=@search.result.page(params[:page]).per(5)
  end

  it "renders a list of ptcourses" do
    render

    assert_select "h1", :text => I18n.t('staff.training.course.title')
    assert_select "a[href=?]", new_staff_training_ptcourse_path, :text => I18n.t("actions.new")
    assert_select "a", :text => I18n.t('actions.search')
    assert_select "a[href=?]", ptcourse_list_staff_training_ptcourses_path(params.merge(format: 'pdf' )), :text => I18n.t('actions.print'), :count => 1
    
    #headers
    assert_select "tr>th", :text => I18n.t('staff.training.course.name')
    assert_select "th", :text => I18n.t('staff.training.course.provider')
    assert_select "th", :text => I18n.t('staff.training.course.duration')
    assert_select "th", :text => I18n.t('staff.training.course.cost')
    assert_select "th", :text => I18n.t('staff.training.course.description')
    assert_select "th", :text => I18n.t('staff.training.course.approval')
    
    #record lines
    assert_select "td>a[href=?]", staff_training_ptcourse_path(@ptcourse1), :text => @ptcourse1.name, :count => 1
    assert_select "td>a[href=?]", staff_training_ptcourse_path(@ptcourse2), :text => @ptcourse2.name, :count => 1
    assert_select "td", :text => @ptcourse1.provider.try(:name)
    assert_select "td", :text => @ptcourse2.provider.try(:name)
    expect(rendered).to match("#{number_with_precision(@ptcourse1.duration, precision: 0)}")
    expect(rendered).to match("#{number_with_precision(@ptcourse2.duration, precision: 0)}")
    expect(rendered).to match("#{(DropDown::DURATION_TYPE.find_all{|disp, value| value == @ptcourse1.duration}).map {|disp, value| disp} [0]}")
    expect(rendered).to match("#{(DropDown::DURATION_TYPE.find_all{|disp, value| value == @ptcourse2.duration}).map {|disp, value| disp} [0]}")
    assert_select "td", :text => ringgols(@ptcourse1.cost)
    assert_select "td", :text => ringgols(@ptcourse2.cost)
    expect(rendered).to match("#{truncate(@ptcourse1.description, :length => 80)}")
    expect(rendered).to match("#{truncate(@ptcourse2.description, :length => 80)}")
    expect(rendered).to match("... [more]"), :count => 1
    assert_select "a[href=?]", staff_training_ptcourse_path(@ptcourse1), :text => "... [more]"
    assert_select "td>i.fa.fa-check", 1
    assert_select "td>i.fa.fa-times", 1

  end
end