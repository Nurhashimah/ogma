require 'rails_helper'

RSpec.describe "training/programmes/new", :type => :view do
  before(:each) do
    @admin_user=FactoryGirl.create(:admin_user)
    sign_in(@admin_user)
    @programme = FactoryGirl.build(:programme)
  end

  it "renders the edit programme form" do
    render

    assert_select "h1", :text => I18n.t('training.programme.new_programme')
    
    #the FORM starts here
    assert_select "form[action=?][method=?]", training_programmes_path, "post" do
      
      assert_select "input#programme_code[name=?]", "programme[code]"
      assert_select "select#programme_course_type[name=?]", "programme[course_type]"
      assert_select "input#programme_name[name=?]", "programme[name]"
      assert_select "input#programme_duration[name=?]", "programme[duration]"
      assert_select "select#programme_durationtype[name=?]", "programme[durationtype]"
      assert_select "select#programme_level[name=?]", "programme[level]"
      assert_select "select#programme_credits[name=?]", "programme[credits]"
      assert_select "select#programme_status[name=?]", "programme[status]"

      # buttons links
      assert_select "a[href=?]", training_programmes_path, {text: I18n.t("helpers.links.back")}      
      assert_select "input.btn.btn-primary[name=?][type=?][value=?]", "commit", "submit", I18n.t('create')
      
    end
    #the FORM ends here
    
  end
end