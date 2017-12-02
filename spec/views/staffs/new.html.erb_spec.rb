require 'rails_helper'

RSpec.describe "staff/staffs/new", :type => :view do
  before(:each) do
    @college=FactoryGirl.create(:college)
    @grade=FactoryGirl.create(:employgrade)
    @staff=FactoryGirl.build(:basic_staff_with_position, college: @college, staffgrade: @grade)
    @info=@staff
    @admin_user=FactoryGirl.create(:admin_user)
    sign_in(@admin_user)
  end

  it "renders new staff form" do
    render

    assert_select "h1", :text => I18n.t('staff.new')
    
    #the FORM starts here
    assert_select "form[action=?][method=?]", staff_infos_path, "post" do
      
      #info tab
      assert_select "input#staff_icno[name=?]", "staff[icno]"
      assert_select "select#staff_titlecd_id[name=?]", "staff[titlecd_id]"
      assert_select "input#staff_name[name=?]", "staff[name]"   
      assert_select "input#staff_code[name=?]", "staff[code]"
      assert_select "input#staff_fileno[name=?]", "staff[fileno]"
      assert_select "input#staff_coemail[name=?]", "staff[coemail]"
      assert_select "input#staff_cobirthdt[name=?]", "staff[cobirthdt]"

      #personal details tab
      assert_select "select#staff_staff_shift_id[name=?]", "staff[staff_shift_id]"
      assert_select "input#staff_thumb_id[name=?]", "staff[thumb_id]"
      assert_select "input#staff_birthcertno[name=?]", "staff[birthcertno]"
      assert_select "select#staff_bloodtype[name=?]", "staff[bloodtype]"
      assert_select "input#staff_gender_1[name=?]", "staff[gender]"
      assert_select "input#staff_gender_2[name=?]", "staff[gender]"
      assert_select "input#staff_cooftelno[name=?]", "staff[cooftelno]"
      assert_select "input#staff_cooftelext[name=?]", "staff[cooftelext]"
      assert_select "input#staff_phonecell[name=?]", "staff[phonecell]"
      assert_select "input#staff_phonehome[name=?]", "staff[phonehome]"
      assert_select "textarea#staff_addr[name=?]", "staff[addr]"
      assert_select "input#staff_poskod_id[name=?]", "staff[poskod_id]"
      assert_select "select#staff_mrtlstatuscd[name=?]", "staff[mrtlstatuscd]"
      assert_select "select#staff_statecd[name=?]", "staff[statecd]"
      assert_select "select#staff_race[name=?]", "staff[race]"
      assert_select "select#staff_religion[name=?]", "staff[religion]"
      assert_select "select#staff_country_cd[name=?]", "staff[country_cd]"
      
      #upload photo tab
      assert_select "input#staff_photo[name=?][type=?]", "staff[photo]", "file"
      
      #employment details tab
      assert_select "select#staff_staffgrade_id[name=?]", "staff[staffgrade_id]"
      assert_select "select#staff_rank_id[name=?]", "staff[rank_id]"
      assert_select "select#staff_employstatus[name=?]", "staff[employstatus]"
      assert_select "select#staff_appointstatus[name=?]", "staff[appointstatus]"
      assert_select "input#staff_appointdt[name=?]", "staff[appointdt]"
      assert_select "input#staff_confirmdt[name=?]", "staff[confirmdt]"
      assert_select "input#staff_pension_confirm_date[name=?]", "staff[pension_confirm_date]"
      assert_select "select#staff_pensionstat[name=?]", "staff[pensionstat]"
      assert_select "input#staff_pensiondt[name=?]", "staff[pensiondt]"
      assert_select "input#staff_schemedt[name=?]", "staff[schemedt]"
      assert_select "input#staff_posconfirmdate[name=?]", "staff[posconfirmdate]"
      assert_select "input#staff_wealth_decleration_date[name=?]", "staff[wealth_decleration_date]"
      assert_select "input#staff_promotion_date[name=?]", "staff[promotion_date]"
      assert_select "input#staff_reconfirmation_date[name=?]", "staff[reconfirmation_date]"
      assert_select "input#staff_to_current_grade_date[name=?]", "staff[to_current_grade_date]"
      assert_select "input#staff_salary_no[name=?]", "staff[salary_no]"
      assert_select "input#staff_starting_salary[name=?]", "staff[starting_salary]"
      assert_select "input#staff_current_salary[name=?]", "staff[current_salary]"
      assert_select "input#staff_allowance[name=?]", "staff[allowance]"
      assert_select "select#staff_appointby[name=?]", "staff[appointby]"
      assert_select "select#staff_svchead[name=?]", "staff[svchead]"
      assert_select "select#staff_svctype[name=?]", "staff[svctype]"
      assert_select "select#staff_uniformstat[name=?]", "staff[uniformstat]"
      
      # finance details tab
      assert_select "input#staff_kwspcode[name=?]", "staff[kwspcode]"
      assert_select "input#staff_taxcode[name=?]", "staff[taxcode]"
      
      # buttons links
      assert_select "a[href=?]", staff_infos_path, {text: I18n.t("helpers.links.back")}
#       also works
#       assert_select "a.btn.btn-default>i.fa.fa-arrow-left"
      
      assert_select "input.btn.btn-primary[name=?][type=?][value=?]", "commit", "submit", I18n.t('create')
      
    end
    #the FORM ends here
    
    # qualifications tab - header line
    expect(rendered).to match("#{I18n.t('staff.qualifications.level_id')}")
    expect(rendered).to match("#{I18n.t('staff.qualifications.qname')}")
    expect(rendered).to match("#{I18n.t('staff.qualifications.institute')}")
    
    # finance details tab - header line
    expect(rendered).to match("#{I18n.t('staff.banks.title')}")
    expect(rendered).to match("#{I18n.t('staff.banks.bankaccno')}")
    expect(rendered).to match("#{I18n.t('staff.banks.bankacctype')}")
    expect(rendered).to match("#{I18n.t('staff.banks.bankname')}")
    expect(rendered).to match("#{I18n.t('staff.insurance_policies.title')}")
    expect(rendered).to match("#{I18n.t('staff.insurance_policies.insurance_type')}")
    expect(rendered).to match("#{I18n.t('staff.insurance_policies.policy_no')}")
    expect(rendered).to match("#{I18n.t('staff.insurance_policies.company_id')}")
    
    # loans tab
    expect(rendered).to match("#{I18n.t('staff.loans.ltype')}")
    expect(rendered).to match("#{I18n.t('staff.loans.accno')}")
    expect(rendered).to match("#{I18n.t('staff.loans.startdt')}")
    expect(rendered).to match("#{I18n.t('staff.loans.durationmn')}")
    expect(rendered).to match("#{I18n.t('staff.loans.amount')}")
    expect(rendered).to match("#{I18n.t('staff.loans.deductions')}")
    expect(rendered).to match("#{I18n.t('staff.loans.firstdate')}")
    expect(rendered).to match("#{I18n.t('staff.loans.enddate')}")
    expect(rendered).to match("#{I18n.t('staff.loans.enddeduction')}")
    
    # emergency contact information  
    expect(rendered).to match("#{I18n.t('staff.contacts.kintype_id')}")
    expect(rendered).to match("#{I18n.t('staff.name')}")
    expect(rendered).to match("#{I18n.t('staff.contacts.kinmykadno')}")
    expect(rendered).to match("#{I18n.t('staff.contacts.phone')}")
    expect(rendered).to match("#{I18n.t('staff.contacts.profession')}")
    expect(rendered).to match("#{I18n.t('staff.contacts.kinaddr')}")
    
  end
end