require 'rails_helper'

RSpec.describe "staff/staff_appraisals/edit", :type => :view do
  before(:each) do
    @staff_user=FactoryGirl.create(:staff_user)
    sign_in(@staff_user)
    @staff_appraisal=FactoryGirl.create(:staff_appraisal, staff_id: @staff_user.userable_id)
    # NOTE :factory --> limit access to Edit page to PYD (edit -> is_skt_submit==false)
  end

  it "renders the edit staff_appraisal form" do
    render

    assert_select "h1", :text => "#{I18n.t('staff.staff_appraisal.edit')}"
    
    #the FORM starts here
    assert_select "form[action=?][method=?]", staff_staff_appraisal_path(@staff_appraisal), "post" do
      
      puts "#{@staff_appraisal.appraised.name}"
      
      assert_select "dl>dt", :text => I18n.t('evaluation.form.name')
      assert_match "#{@staff_user.userable.mykad_with_staff_name}", "#{@staff_appraisal.appraised.mykad_with_staff_name}"
      
      assert_select "dl>dt", :text => I18n.t('position.name')
      assert_select "dd", :text => @staff_appraisal.appraised.positions[0].try(:name)
      
      assert_select "dl>dt", :text => I18n.t('evaluation.form.evaluationdate')
      assert_select "dd", :text => (@staff_appraisal.evaluation_year).year
      
      assert_select "select#staff_appraisal_staff_appraisal_skts_attributes_0_priority[name=?]", "staff_appraisal[staff_appraisal_skts_attributes][0][priority]"
      
      assert_select "textarea#staff_appraisal_staff_appraisal_skts_attributes_0_description[name=?]", "staff_appraisal[staff_appraisal_skts_attributes][0][description]"
      
      assert_select "textarea#staff_appraisal_staff_appraisal_skts_attributes_0_indicator_desc_cost[name=?]", "staff_appraisal[staff_appraisal_skts_attributes][0][indicator_desc_cost]"
      
      assert_select "textarea#staff_appraisal_staff_appraisal_skts_attributes_0_indicator_desc_quality[name=?]", "staff_appraisal[staff_appraisal_skts_attributes][0][indicator_desc_quality]"
      
      assert_select "textarea#staff_appraisal_staff_appraisal_skts_attributes_0_indicator_desc_quantity[name=?]", "staff_appraisal[staff_appraisal_skts_attributes][0][indicator_desc_quantity]"
      
      assert_select "textarea#staff_appraisal_staff_appraisal_skts_attributes_0_indicator_desc_time[name=?]", "staff_appraisal[staff_appraisal_skts_attributes][0][indicator_desc_time]"
      
      assert_select "textarea#staff_appraisal_staff_appraisal_skts_attributes_0_target_cost[name=?]", "staff_appraisal[staff_appraisal_skts_attributes][0][target_cost]"
      
      assert_select "textarea#staff_appraisal_staff_appraisal_skts_attributes_0_target_quality[name=?]", "staff_appraisal[staff_appraisal_skts_attributes][0][target_quality]"
      
      assert_select "textarea#staff_appraisal_staff_appraisal_skts_attributes_0_target_quantity[name=?]", "staff_appraisal[staff_appraisal_skts_attributes][0][target_quantity]"
      
      assert_select "textarea#staff_appraisal_staff_appraisal_skts_attributes_0_target_time[name=?]", "staff_appraisal[staff_appraisal_skts_attributes][0][target_time]"
      
      assert_select "input#is_skt_submit[name=?]", "staff_appraisal[is_skt_submit]"
      
      assert_select "a[href=?]", staff_staff_appraisal_path(@staff_appraisal), {text: I18n.t("helpers.links.back")}
#       also works
#       assert_select "a.btn.btn-default>i.fa.fa-arrow-left"
      
      assert_select "input.btn.btn-primary[name=?][type=?][value=?]", "commit", "submit", I18n.t('update')
      
    end
    #the FORM ends here
    
  end
end