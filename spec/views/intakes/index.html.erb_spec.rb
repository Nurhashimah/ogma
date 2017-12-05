require 'rails_helper'

RSpec.describe "training/intakes/index", :type => :view do
  subject { page }
  before(:each) do
    @college=FactoryGirl.create(:college)
    @admin_user=FactoryGirl.create(:admin_user, college_id: @college.id)
    sign_in(@admin_user)
    @intake1 = FactoryGirl.create(:intake, is_active: true) 
    @intake2 = FactoryGirl.create(:intake, is_active: true) 
    @search=Intake.search(params[:q])
    @intakes3=@search.result.page(params[:page]).per(5)
  end

  it "renders a list of intakes" do
    render

    #headers
    assert_select "h1", :text => I18n.t('training.intake.title')
    assert_select "a", :text => I18n.t('actions.search')
    assert_select "tr>th", :text => "Siri"
    assert_select "th>a", :text => I18n.t('training.intake.division_name')
    assert_select "th>a", :text => I18n.t('training.intake.register_on')
    assert_select "th>a", :text => I18n.t('training.intake.programme_id')
    assert_select "th>a", :text => I18n.t('training.intake.coordinator')                                  
    assert_select "th>a", :text => I18n.t('training.intake.is_active')
    
    #record lines
    assert_select "a[href=?]", training_intake_path(@intake1), :text => @intake1.name, :count => 1
    assert_select "a[href=?]", training_intake_path(@intake2), :text => @intake2.name, :count => 1

    assert_select "tr>td>a", :text => @intake1.name
    assert_select "tr>td>a", :text => @intake2.name
    
# puts "\n(1) #{@intake1.division['0']['name']} - #{@intake1.division['0']['total_student']} #{I18n.t( 'training.intake.person')}\n<br>\n(2) #{@intake1.division['1']['name']} - #{@intake1.division['1']['total_student']} #{I18n.t( 'training.intake.person')}\n<br>\n(3) #{@intake1.division['2']['name']} - #{@intake1.division['2']['total_student']} #{I18n.t( 'training.intake.person')}\n<br>\n(4) #{@intake1.division['3']['name']} - #{@intake1.division['3']['total_student']} #{I18n.t( 'training.intake.person')}\n<br>"
#     TODO - above

    assert_select "td", :text => @intake1.try(:register_on).try(:strftime, '%d %b %Y')
    assert_select "td", :text => @intake2.try(:register_on).try(:strftime, '%d %b %Y')
    assert_select "td", :text => @intake1.programme.programme_list
    assert_select "td", :text => @intake2.programme.programme_list
    assert_select "td", :text => @intake1.coordinator.try(:name)
    assert_select "td", :text => @intake2.coordinator.try(:name)
    assert_select "td>i.fa.fa-check", 2
  end
end