require 'rails_helper'

RSpec.describe "cofiles/index", :type => :view do
  before(:each) do
    @admin_user=FactoryGirl.create(:admin_user)
    sign_in(@admin_user)
    @cofile1=FactoryGirl.create(:cofile)
    @cofile2=FactoryGirl.create(:cofile)
    @search=Cofile.search(params[:q])
    @cofiles=@search.result.page(params[:page]).per(5)
  end

  it "renders a list of cofiles" do
    render
    assert_select "h1", :text => I18n.t('cofile.index'), :count => 1
    assert_select "th>a", :text => I18n.t('cofile.cofileno'), :count => 1
    assert_select "th>a", :text => I18n.t('cofile.name'), :count => 1
    assert_select "th>a", :text => I18n.t('cofile.location'), :count => 1
    assert_select "th>a", :text => I18n.t('cofile.owner'), :count => 1
    assert_select "th>a", :text => I18n.t('cofile.onloan_to'), :count => 1
    assert_select "th>a", :text => I18n.t('cofile.onloandt'), :count => 1
    
    assert_select "tr>td>a[href=?]", cofile_path(@cofile1), :text => @cofile1.cofileno.strip
    assert_select "tr>td>a[href=?]", cofile_path(@cofile2), :text => @cofile2.cofileno.strip
    assert_select "td", :text => @cofile1.name
    assert_select "td", :text => @cofile2.name
    assert_select "td", :text => @cofile1.location
    assert_select "td", :text => @cofile2.location
    assert_select "td", :text => @cofile1.try(:owner).try(:staff_with_rank).strip
    assert_select "td", :text => @cofile2.try(:owner).try(:staff_with_rank).strip
    assert_select "td", :text => @cofile1.try(:borrower).try(:staff_with_rank).strip
    assert_select "td", :text => @cofile2.try(:borrower).try(:staff_with_rank).strip
    assert_select "td", :text => @cofile1.onloandt.try(:strftime, '%d-%m-%Y')
    assert_select "td", :text => @cofile2.onloandt.try(:strftime, '%d-%m-%Y')
  end
end



