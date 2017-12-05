require 'rails_helper'

RSpec.describe "staff/staff_appraisals/show", :type => :view do
  before(:each) do
    @admin_user=FactoryGirl.create(:admin_user)
    sign_in(@admin_user)
    @staff_appraisal=FactoryGirl.create(:staff_appraisal, staff_id: @admin_user.userable_id)
    # NOTE :factory --> limit access to Edit page to PYD (edit -> is_skt_submit==false)
  end

  it "renders attributes in <p>" do
    render
    
    assert_select "h1", :text => I18n.t('staff.staff_appraisal.title')
    assert_select "b", :text => I18n.t('evaluation.form.title_part1')
    
    assert_select "dl>dt", :text => I18n.t('evaluation.form.name')
    assert_match "#{@admin_user.userable.mykad_with_staff_name}", "#{@staff_appraisal.appraised.mykad_with_staff_name}"
      
    assert_select "dl>dt", :text => I18n.t('position.name')
    assert_select "dd", :text => @staff_appraisal.appraised.positions[0].try(:name)
    
    assert_select "dl>dt", :text => I18n.t('evaluation.form.evaluationdate')
    assert_select "dd", :text => (@staff_appraisal.evaluation_year).year
    
    assert_select "a[href=?]", staff_staff_appraisals_path, {text: I18n.t("helpers.links.back")}
    assert_select "a", 4
    
#     assert_select "a[href=?]", edit_staff_staff_appraisal_path(@staff_appraisal), {text: I18n.t("helpers.links.edit")}
#     assert_select "a[href=?]", staff_staff_appraisal_path(@staff_appraisal), {text: I18n.t("helpers.links.destroy")}
    
    assert_select "dl>dt", :text => I18n.t('evaluation.skt.priority')
    assert_select "dd", :text => @staff_appraisal.staff_appraisal_skts[0].priority
    
    assert_select "dl>dt", :text => I18n.t('evaluation.skt.description')
    assert_select "dd", :text => @staff_appraisal.staff_appraisal_skts[0].description
    
    assert_select "th", :text => I18n.t('evaluation.skt.performance')
    assert_select "th", :text => I18n.t('evaluation.skt.target')
    assert_select "th", :text => I18n.t('evaluation.skt_review.achievement')
    assert_select "th", :text => "%" # I18n.t('evaluation.skt_review.progress')
    assert_select "th", :text => I18n.t('evaluation.skt_review.notes')
  
    assert_select "th", :text => I18n.t('evaluation.skt.cost')
    assert_select "th", :text => I18n.t('evaluation.skt.quality')
    assert_select "th", :text => I18n.t('evaluation.skt.quantity')
    assert_select "th", :text => I18n.t('evaluation.skt.time')
    
    assert_select "td", :text => @staff_appraisal.staff_appraisal_skts[0].indicator_desc_cost
    assert_select "td", :text => @staff_appraisal.staff_appraisal_skts[0].target_cost
    assert_select "td", :text => @staff_appraisal.staff_appraisal_skts[0].indicator_desc_quality
    assert_select "td", :text => @staff_appraisal.staff_appraisal_skts[0].target_quality
    assert_select "td", :text => @staff_appraisal.staff_appraisal_skts[0].indicator_desc_quantity
    assert_select "td", :text => @staff_appraisal.staff_appraisal_skts[0].target_quantity
    assert_select "td", :text => @staff_appraisal.staff_appraisal_skts[0].indicator_desc_time
    assert_select "td", :text => @staff_appraisal.staff_appraisal_skts[0].target_time
   
  end
end

  