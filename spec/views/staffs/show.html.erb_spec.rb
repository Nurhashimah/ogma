require 'rails_helper'

RSpec.describe "staff/staffs/show", :type => :view do
  before(:each) do
    @college=FactoryGirl.create(:college)
    @grade=FactoryGirl.create(:employgrade)
    @rank=FactoryGirl.create(:rank)
    @parent_staff=FactoryGirl.create(:basic_staff, name: "Parent Staff")
    @qualification=FactoryGirl.create(:staff_qualification)
    @bankaccount=FactoryGirl.create(:bankaccount)
    @insurance_policy=FactoryGirl.create(:insurance_policy)
    @loan=FactoryGirl.create(:loan)
    @staff=FactoryGirl.create(:basic_staff, college: @college, staffgrade: @grade, rank: @rank, cooftelno: "12345678", cooftelext: "90", qualifications: [@qualification], bankaccounts: [@bankaccount], insurance_policies: [@insurance_policy], loans: [@loan])
    @parent_position=FactoryGirl.create(:position, staff: @parent_staff, ancestry_depth: 0,  name: "Position1 Orgchart")
    @position=FactoryGirl.create(:position, staff: @staff, name: "Position2 Orgchart", ancestry_depth: 1, parent_id: @parent_position.id)
    @info=@staff
    @admin_user=FactoryGirl.create(:admin_user, userable: @staff, college: @college)
    sign_in(@admin_user)
  end

  it "renders attributes in <dl>" do
    render
    
#     puts "#{@admin_user.roles.pluck(:authname)}"
    
    assert_select "h1", :text => @staff.name
      
    #tab_info
    assert_select "dl>dt", :text => I18n.t('staff.icno')
    assert_select "dd", :text => @staff.icno
    assert_select "dl>dt", :text => I18n.t('staff.name')
    assert_select "dd", :text => @staff.staff_with_rank
    assert_select "dl>dt", :text => I18n.t('staff.code')
    assert_select "dd", :text => @staff.code
    assert_select "dl>dt", :text => I18n.t('staff.fileno')
    assert_select "dd", :text => @staff.fileno
    assert_select "dl>dt", :text => I18n.t('staff.position')
    assert_select "dd", :text => @staff.try(:position).try(:name)
    assert_select "dl>dt", :text => I18n.t('staff.coemail')
    assert_select "dd", :text => @staff.coemail
    assert_select "dl>dt", :text => I18n.t('staff.cobirthdt')
    assert_select "dd", :text => @staff.cobirthdt.try(:strftime, '%d %b %Y')
    assert_select "dl>dt", :text => I18n.t('staff.birthcertno')
    assert_select "dd", :text => @staff.birthcertno
    assert_select "dl>dt", :text => I18n.t('staff.age')
    assert_select "dd", :text => @staff.age
    
    #tab_personal
    assert_select "dl>dt", :text => I18n.t('staff.bloodtype')
    assert_select "dd", :text =>  (DropDown::BLOOD_TYPE.find_all{|disp, value| value == @staff.bloodtype}).map {|disp, value| disp}[0]
    assert_select "dl>dt", :text => I18n.t('staff.gender')
    assert_select "dd", :text =>  (DropDown::GENDER.find_all{|disp, value| value == @staff.gender.to_s}).map {|disp, value| disp}[0]
    assert_select "dl>dt", :text => I18n.t('staff.cooftelno')
    assert_select "dd", :text => "12345678\nExt\n90".html_safe
    assert_select "dl>dt", :text => I18n.t('staff.phonecell')
    assert_select "dd", :text => @staff.phonecell
    assert_select "dl>dt", :text => I18n.t('staff.phonehome')
    assert_select "dd", :text => @staff.phonehome
    assert_select "dl>dt", :text => I18n.t('staff.address')
    assert_select "dd", :text => @staff.addr
    assert_select "dl>dt", :text => I18n.t('staff.poskod_id')
    assert_select "dd", :text => @staff.poskod_id
    assert_select "dl>dt", :text => I18n.t('staff.mrtlstatuscd')
    assert_select "dd", :text => (DropDown::MARITAL_STATUS.find_all{|disp, value| value == @staff.mrtlstatuscd }).map {|disp, value| disp}[0]
    assert_select "dl>dt", :text => I18n.t('staff.statecd')
    assert_select "dd", :text => (DropDown::STATECD.find_all{|disp, value| value == @staff.statecd}).map {|disp, value| disp}[0]
    assert_select "dl>dt", :text => I18n.t('staff.race')
    assert_select "dd", :text =>  (DropDown::RACE.find_all{|disp, value| value == @staff.race}).map {|disp, value| disp}[0]
    assert_select "dl>dt", :text => I18n.t('staff.religion')
    assert_select "dd", :text =>  (DropDown::RELIGION.find_all{|disp, value| value == @staff.religion}).map {|disp, value| disp}[0]
    assert_select "dl>dt", :text => I18n.t('staff.country_cd')
    assert_select "dd", :text =>  (DropDown::NATIONALITY.find_all{|disp, value| value == @staff.country_cd}).map {|disp, value| disp}[0]
    assert_select "dl>dt", :text => I18n.t('staff.thumb')
    assert_select "dd", :text => @staff.thumb_id
    assert_select "dl>dt", :text => I18n.t('staff.shift')
    assert_select "dd", :text => @staff.staff_shift.try(:start_end)
    
    #tab_employment
    assert_select "dl>dt", :text => I18n.t('staff.code')
    assert_select "dd", :text => @staff.code
    assert_select "dl>dt", :text => I18n.t('staff.fileno')
    assert_select "dd", :text => @staff.fileno
    assert_select "dl>dt", :text => I18n.t('staff.rank_id')
    assert_select "dd", :text => @staff.try(:rank).try(:name)
    assert_select "dl>dt", :text => I18n.t('staff.coemail')
    assert_select "dd", :text => @staff.coemail
    assert_select "dl>dt", :text => I18n.t('staff.cobirthdt')
    assert_select "dd", :text => @staff.cobirthdt.try(:strftime, '%d %b %Y')
    assert_select "dl>dt", :text => I18n.t('staff.birthcertno')
    assert_select "dd", :text => @staff.birthcertno
    assert_select "dl>dt", :text => I18n.t('staff.age')
    assert_select "dd", :text => @staff.age
    
#     assert_select "dl>dt", :text => I18n.t('staff.grade_id')
#     assert_select "dd", :text => @staff.staffgrade.try(:name_and_group)
#     puts "#{@staff.staffgrade.try(:name_and_group)}"
    
    assert_select "dl>dt", :text => I18n.t('staff.position')
    expect(rendered).to match("Position2 Orgchart")
    
    assert_select "dl>dt", :text => I18n.t('staff.reports_to')
    expect(rendered).to match("Position1 Orgchart")
    expect(rendered).to match("Parent Staff")
    
    assert_select "dl>dt", :text => I18n.t('staff.employstatus')
    assert_select "dd", :text =>  (DropDown::STAFF_STATUS.find_all{|disp, value| value == @staff.employstatus}).map {|disp, value| disp}[0]
    assert_select "dl>dt", :text => I18n.t('staff.appointstatus')
    assert_select "dd", :text => (DropDown::APPOINTMENT.find_all{|disp, value| value == @staff.appointstatus.to_s}).map {|disp, value| disp}[0]
    
    assert_select "dl>dt", :text => I18n.t('staff.appointdt')
    assert_select "dd", :text => @staff.appointdt.try(:strftime, '%d-%b-%Y')
    
    assert_select "dl>dt", :text => I18n.t('staff.schemedt')
    assert_select "dl>dt", :text => I18n.t('staff.confirmdt')
    assert_select "dl>dt", :text => I18n.t('staff.posconfirmdate')
    assert_select "dl>dt", :text => I18n.t('staff.wealth_decleration_date')
    assert_select "dl>dt", :text => I18n.t('staff.promotion_date')
    assert_select "dl>dt", :text => I18n.t('staff.reconfirmation_date')
    assert_select "dl>dt", :text => I18n.t('staff.current_grade_date')
    
    assert_select "dl>dt", :text => I18n.t('staff.salary_no')
    assert_select "dd", :text => @staff.salary_no
    assert_select "dl>dt", :text => I18n.t('staff.starting_salary')
    assert_select "dd", :text =>  ringgols(@staff.starting_salary)
    assert_select "dl>dt", :text => I18n.t('staff.current_salary')
    assert_select "dd", :text =>  ringgols(@staff.current_salary)
    assert_select "dl>dt", :text => I18n.t('staff.allowance')
    assert_select "dd", :text => ringgols(@staff.allowance)
    assert_select "dl>dt", :text => I18n.t('staff.appointby')
    assert_select "dd", :text => (DropDown::APPOINTED.find_all{|disp, value| value == @staff.appointby }).map {|disp, value| disp}[0]
    assert_select "dl>dt", :text => I18n.t('staff.svchead')
    assert_select "dd", :text => (DropDown::HOS.find_all{|disp, value| value == @staff.svchead }).map {|disp, value| disp}[0]
    assert_select "dl>dt", :text => I18n.t('staff.svctype')
    assert_select "dd", :text => (DropDown::TOS.find_all{|disp, value| value == @staff.svctype }).map {|disp, value| disp}[0]
    assert_select "dl>dt", :text => I18n.t('staff.pensionstat')
    assert_select "dd", :text => (DropDown::PENSION.find_all{|disp, value| value == @staff.pensionstat}).map {|disp, value| disp}[0]
    
    assert_select "dl>dt", :text => I18n.t('staff.pensiondt')    
    assert_select "dl>dt", :text => I18n.t('staff.pension_confirm_date')
    
    assert_select "dd", :text => "-", :count => 9#10 #9(tab_employment) + 3(tab_loan)
    
    assert_select "dl>dt", :text => I18n.t('staff.uniformstat')
    assert_select "dd", :text => (DropDown::UNIFORM.find_all{|disp, value| value == @staff.uniformstat }).map {|disp, value| disp}[0]
    
    # tab_qualifications
    assert_select "dl>dt", :text => I18n.t('staff.qualifications.level_id') + ":"
    assert_select "dd>strong", :text => (DropDown::QUALIFICATION_LEVEL.find_all{|disp, value| value == @qualification.level_id}).map {|disp, value| disp}[0]
    assert_select "dl>dt", :text => I18n.t('staff.qualifications.qname') + ":"
    assert_select "dd", :text => @qualification.qname
    assert_select "dl>dt", :text => I18n.t('staff.qualifications.institute') + ":"
    assert_select "dd", :text => @staff.qualifications.first.institute
    
    #tab_finance
    assert_select "dl>dt", :text => I18n.t('staff.finance.kwspcode') + ":"
    assert_select "dd", :text => @staff.kwspcode
    
    assert_select "dl>dt", :text => I18n.t('staff.finance.taxcode') + ":"
    assert_select "dd", :text => @staff.taxcode
    
    assert_select "dl>dt", :text => I18n.t('banks.long_name') + ":"
    assert_select "dd", :text => @staff.bankaccounts.first.bank.long_name
    
    assert_select "dl>dt", :text => I18n.t('staff.banks.bankaccno') + ":"
    assert_select "dd", :text => @staff.bankaccounts.first.account_no

    assert_select "dl>dt", :text => I18n.t('staff.banks.bankacctype') + ":"
    assert_select "dd", :text =>  (DropDown::BANKTYPE.find_all{|disp, value| value == @staff.bankaccounts.first.account_type }).map {|disp, value| disp}[0]
  
    assert_select "dl>dt", :text => I18n.t('staff.insurance_policies.company_id') + ":"
    assert_select "dd>strong", :text => @staff.insurance_policies.first.insurance_company.try(:long_name)
    
    assert_select "dl>dt", :text => I18n.t('staff.insurance_policies.policy_no') + ":"
    assert_select "dd", :text => @staff.insurance_policies.first.policy_no
    
    assert_select "dl>dt", :text => I18n.t('staff.insurance_policies.insurance_type') + ":"
    assert_select "dd", :text => @staff.insurance_policies.first.render_insurance_type

    #tab_loan
    assert_select "dl>dt", :text => I18n.t('staff.loans.ltype') + ":"
    assert_select "dd>strong", :text => (DropDown::LOAN_TYPE.find_all{|disp, value| value == @staff.loans.first.ltype }).map {|disp, value| disp}[0]

    assert_select "dl>dt", :text => I18n.t('staff.loans.accno') + ":"
    assert_select "dd", :text => @staff.loans.first.accno
        
    assert_select "dl>dt", :text => I18n.t('staff.loans.startdt') + ":"
    assert_select "dd", :text => l(@staff.loans.first.startdt)
    
    assert_select "dl>dt", :text => I18n.t('staff.loans.durationmn') + ":"
    assert_select "dd", :text => @staff.loans.first.durationmn.to_s+" Months"
    
    assert_select "dl>dt", :text => I18n.t('staff.loans.deductions') + ":"
    assert_select "dd", :text => ringgols(@staff.loans.first.deductions)
    
    assert_select "dl>dt", :text => I18n.t('staff.loans.firstdate') + ":"
    assert_select "dd", :text => l(@staff.loans.first.firstdate) 
    
    assert_select "dl>dt", :text => I18n.t('staff.loans.enddate') + ":"
    assert_select "dd", :text => l(@staff.loans.first.enddate)
    
    assert_select "dl>dt", :text => I18n.t('staff.loans.enddeduction') + ":"
    assert_select "dd", :text => ringgols(@staff.loans.first.enddeduction)
    
#     assert_select "dl>dt", :text => I18n.t()
#     assert_select "dd", :text => @staff.
    
    
    assert_select "a[href=?]", staff_infos_path, {text: "#{I18n.t("helpers.links.back")}" }
    assert_select "a[href=?]", edit_staff_info_path(@staff), {text: I18n.t("helpers.links.edit")}
    assert_select "a[href=?]", staff_info_path(@staff), {text: I18n.t("helpers.links.destroy")}
   
  end
end

  