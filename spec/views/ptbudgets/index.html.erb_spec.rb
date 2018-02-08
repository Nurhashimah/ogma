require 'rails_helper'

RSpec.describe "staff_training/ptbudgets/index", :type => :view do
  
  before(:each) do
    @admin_user=FactoryGirl.create(:admin_user)
    sign_in(@admin_user)
    @ptbudget1 = FactoryGirl.create(:ptbudget, fiscalstart: "#{Date.today.year}-01-01", budget: 20000.00)
    @ptbudget2 = FactoryGirl.create(:ptbudget, fiscalstart: "#{Date.today.year}-06-01", budget: 5000.00)
    @search=Ptbudget.search(params[:q])
    @ptbudgets=@search.result.page(params[:page]).per(5)
    @ptbudgets_multiple=Ptbudget.where('id IN(?) and id!=?', Ptbudget.where(id: [@ptbudget1.id, @ptbudget2.id]).map(&:id), @ptbudget1.id).order(fiscalstart: :asc)
    heading_budget=Ptbudget.find(@ptbudget1.id)
    @all_budget_recs=Ptbudget.where('fiscalstart >=? and fiscalstart <=?', heading_budget.fiscalstart, heading_budget.fiscalstart+1.year-1.day)
    @all_budget=@all_budget_recs.map(&:budget).sum 
    @latest_balance=@all_budget-@all_budget_recs[0].used_budget
  end

  it "renders a list of ptbudgets" do
    render

    assert_select "h1", :text => I18n.t('staff.training.budget.title')
    assert_select "a[href=?]", new_staff_training_ptbudget_path(:newtype =>"1"), :text => I18n.t("actions.new")
    assert_select "a", :text => I18n.t('actions.search')
    assert_select "a[href=?]", ptbudget_list_staff_training_ptbudgets_path(params.merge(format: 'pdf' )), :text => I18n.t('actions.print'), :count => 1
    
    #headers
    assert_select "tr>th", :text => I18n.t('staff.training.budget.start')
    assert_select "th", :text => I18n.t('staff.training.budget.budget')
    assert_select "th", :text => I18n.t('staff.training.budget.used')
    assert_select "th", :text => I18n.t('staff.training.budget.balance')
    assert_select "th", :text =>"#{ I18n.t('staff.training.budget.balance')} (%)"
    
    #record lines
    assert_select "a[href=?]", staff_training_ptbudget_path(@ptbudget1), :text => "#{l(@ptbudget1.fiscalstart).to_s} #{I18n.t('to')} #{l(@ptbudget1.fiscal_end)}", :count => 1
    
#            +<td>
#        +<a href="/staff_training/ptbudgets/1">01-Jan-2018 To 31-Dec-2018</a>
#        +<!-- =ptbudget.fiscal_end > Date.today -->
#        +<!-- =ptbudget.fiscalstart < Date.today -->
#        +<!-- =[364, 365].include?((ptbudget.fiscal_end-ptbudget.fiscalstart).to_i) -->
#        +<!-- - if ptbudget.fiscal_end > Date.today && ptbudget.fiscal_end <= Date.today.end_of_year -->
#        +&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
#         <a href="/staff_training/ptbudgets/new?newtype=2"><i class="fa fa-plus-square"></i> + Additional Budget</a>
#        +<!-- --aaa-- -->
#        +&nbsp;
#        +</td>
    
#            +<td>
#        +<a href="/staff_training/ptbudgets/1">01-Jan-2018 To 31-Dec-2018</a>
#        +<!-- =ptbudget.fiscal_end > Date.today -->
#        +<!-- =ptbudget.fiscalstart < Date.today -->
#        +<!-- =[364, 365].include?((ptbudget.fiscal_end-ptbudget.fiscalstart).to_i) -->
#        +<!-- - if ptbudget.fiscal_end > Date.today && ptbudget.fiscal_end <= Date.today.end_of_year -->
#        +&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
#        +<a href="/staff_training/ptbudgets/new?newtype=2"><i class="fa fa-plus-square"></i> + Additional Budget</a>
#        +<!-- --aaa-- -->
#        +&nbsp;
#        +</td>

#     expect(rendered).to match("<a href='/staff_training/ptbudgets/new?newtype=2'><i class='fa fa-plus-square'></i> + Additional Budget</a>")
                          
    assert_select "a[href=?]", new_staff_training_ptbudget_path(newtype: "2")#, :text => I18n.t('staff.training.budget.add_budget')   - TODO - to cater i.fa.fa-plus-square w other text - 8Feb2018
    assert_select "td", :text => ringgols(@ptbudget1.budget)
    assert_select "td", :text => ringgols(@ptbudget1.used_budget)
    assert_select "td", :text => ringgols(@ptbudget1.budget_balance)
    assert_select "td", :text => number_with_precision((@ptbudget1.budget_balance.to_f / @ptbudget1.budget.to_f) *  100, :precision => 2)
    
    assert_select "td>a[href=?]", staff_training_ptbudget_path(@ptbudget2), :text => "#{l(@ptbudget2.fiscalstart).to_s} #{I18n.t('to')} #{l(@ptbudget2.fiscal_end)}"
    expect(rendered).to match("#{ringgols(@ptbudget2.budget)}")
    assert_select "td", :text => ringgols(@ptbudget2.budget_balance)
    assert_select "td", :text => number_with_precision((@ptbudget2.budget_balance.to_f / @ptbudget2.acc_budget.to_f) *  100, :precision => 2)
    
    #total line
    assert_select "td", :text => ringgols(@all_budget)
    assert_select "td", :text => ringgols(@all_budget_recs[0].used_budget)
    assert_select "td", :text => ringgols(@latest_balance)
    assert_select "td", :text => number_with_precision((@latest_balance.to_f / @all_budget.to_f) *  100, :precision => 2)

  end
end