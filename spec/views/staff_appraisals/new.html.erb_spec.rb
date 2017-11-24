require 'rails_helper'

RSpec.describe "staff/staff_appraisals/new", :type => :view do
  before(:each) do
    @staff_user=FactoryGirl.create(:staff_user)
    sign_in(@staff_user)
    @staff_appraisal=FactoryGirl.build(:staff_appraisal, staff_id: @staff_user.userable_id)
    # NOTE :factory --> limit access to Edit page to PYD (edit -> is_skt_submit==false)
  end

  it "renders new staff_appraisal form" do
    render

    assert_select "h1", :text => I18n.t('staff.staff_appraisal.new')
    
    assert_select "form[action=?][method=?]", staff_staff_appraisals_path, "post" do
      
      assert_select "b", :text => I18n.t('evaluation.form.title_part1')
      assert_select "select#staff_appraisal_staff_id[name=?]", "staff_appraisal[staff_id]"
      assert_select "input#staff_appraisal_evaluation_year[name=?]", "staff_appraisal[evaluation_year]"
      assert_select "input#is_skt_submit[name=?]", "staff_appraisal[is_skt_submit]"
      
      assert_select "a[href=?]", staff_staff_appraisals_path, {text: I18n.t("helpers.links.back")}
      assert_select "input.btn.btn-primary[name=?][type=?][value=?]", "commit", "submit", I18n.t('create')

    end
  end
end