require 'rails_helper'

RSpec.describe "training/programmes/edit", :type => :view do
  before(:each) do
    @admin_user=FactoryGirl.create(:admin_user)
    sign_in(@admin_user)
    @root = FactoryGirl.create(:programme)
    @module = FactoryGirl.create(:module, parent: @root)
    @subject = FactoryGirl.create(:subject, parent: @module)
    @programme = FactoryGirl.create(:topic, parent: @subject, lecture_d: "00:15:00", tutorial_d: "00:30:00", practical_d: "00:45:00", duration: 1.5, durationtype: "hours")
  end

  it "renders the edit programme form" do
    render

    assert_select "h1", :text => "#{I18n.t('actions.edit')}\nTopic\n#{@programme.name}"
    
    #the FORM starts here
    assert_select "form[action=?][method=?]", training_programme_path(@programme), "post" do
      
      assert_select "input#programme_code[name=?]", "programme[code]"
      assert_select "select#programme_course_type[name=?]", "programme[course_type]"
      
      assert_select "input#programme_lecture_d[name=?]", "programme[lecture_d]"
      assert_select "input#programme_tutorial_d[name=?]", "programme[tutorial_d]"
      assert_select "input#programme_practical_d[name=?]", "programme[practical_d]"
      assert_select "input#programme_subject_abbreviation[name=?]", "programme[subject_abbreviation]"
      
      assert_select "input#programme_name[name=?]", "programme[name]"
      assert_select "input#programme_duration[name=?]", "programme[duration]"
      assert_select "select#programme_durationtype[name=?]", "programme[durationtype]"

      assert_select "select#programme_credits[name=?]", "programme[credits]"
      assert_select "select#programme_status[name=?]", "programme[status]"
      
      # buttons links
      assert_select "a[href=?]", training_programme_path(@programme), {text: I18n.t("helpers.links.back")}
      assert_select "input.btn.btn-primary[name=?][type=?][value=?]", "commit", "submit", I18n.t('update')
      
    end
    #the FORM ends here
    
  end
end