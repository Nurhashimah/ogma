require 'rails_helper'

RSpec.describe "staff_training/ptschedules/index", :type => :view do
  
  before(:each) do
    @admin_user=FactoryGirl.create(:admin_user)
    sign_in(@admin_user)
    @ptcourse1=FactoryGirl.create(:ptcourse)
    @ptcourse2=FactoryGirl.create(:ptcourse)
    @ptschedule1 = FactoryGirl.create(:ptschedule, course: @ptcourse1)
    @ptschedule2 = FactoryGirl.create(:ptschedule, course: @ptcourse2)
    @ptdo=FactoryGirl.create(:ptdo, applicant: @admin_user.userable, ptschedule: @ptschedule1)
    @search=Ptschedule.search(params[:q])
    @ptschedules=@search.result.page(params[:page]).per(5)
  end

  it "renders a list of ptschedules" do
    render

    assert_select "h1", :text => I18n.t('staff.training.schedule.title')
    assert_select "a", :text => I18n.t('actions.search')
    assert_select "a[href=?]", ptschedule_list_staff_training_ptschedules_path(params.merge(format: 'pdf' )), :text => I18n.t('actions.print'), :count => 1
    
    #record lines
    assert_select "span.day", :text => @ptschedule1.start.try(:strftime, "%d")
    assert_select "span.day", :text => @ptschedule2.start.try(:strftime, "%d")
    assert_select "span.month", :text => @ptschedule1.start.try(:strftime, "%b")
    assert_select "span.month", :text => @ptschedule2.start.try(:strftime, "%b")
    assert_select "span.title", :text => @ptschedule1.course.try(:name)
    assert_select "span.title", :text => @ptschedule2.course.try(:name)
    assert_select "p.description", :text => @ptschedule1.course.try(:description)
    assert_select "p.description", :text => @ptschedule2.course.try(:description)
    assert_select "span.footer", :text => "#{@ptschedule1.location}\n#{@ptschedule1.course.provider.try(:name)}"
    assert_select "span.footer", :text => "#{@ptschedule2.location}\n#{@ptschedule2.course.provider.try(:name)}"
    expect(rendered).to match("#{I18n.t('staff.training.schedule.max')}"), :count => 2
    expect(rendered).to match("#{@ptschedule1.max_participants}")
    expect(rendered).to match("#{@ptschedule2.max_participants}")
    expect(rendered).to match("#{I18n.t('staff.training.schedule.min')}"), :count => 2
    expect(rendered).to match("#{@ptschedule1.min_participants}")
    expect(rendered).to match("#{@ptschedule2.min_participants}")
    expect(rendered).to match("#{I18n.t('staff.training.schedule.applied_attended')}"), :count => 1
    assert_select "td>a[href=?]", new_staff_training_ptdo_path(:ptschedule_id => @ptschedule2), :text => I18n.t('staff.training.application_status.title_apply')
    assert_select "td>a[href=?]", staff_training_ptschedule_path(@ptschedule1), :text => I18n.t('staff.training.schedule.manage')

  end
end