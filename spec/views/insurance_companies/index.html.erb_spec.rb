require 'rails_helper'

RSpec.describe "insurance_companies/index", :type => :view do
  before(:each) do
    @admin_user=FactoryGirl.create(:admin_user)
    sign_in(@admin_user)
    @college=FactoryGirl.create(:college)
    @insurance_company1=FactoryGirl.create(:insurance_company, short_name: "Short Name", long_name: "Long Name", active: false, college: @collage)
    @insurance_company2=FactoryGirl.create(:insurance_company, short_name: "Short Name", long_name: "Long Name", active: false, college: @college)
    @search=InsuranceCompany.search(params[:q])
    @insurance_companies=@search.result.page(params[:page]).per(5)
#     assign(:insurance_companies, [
#       InsuranceCompany.create!(
#         :short_name => "Short Name",
#         :long_name => "Long Name",
#         :active => false,
#         :college_id => 1,
#         :data => "MyText"
#       ),
#       InsuranceCompany.create!(
#         :short_name => "Short Name",
#         :long_name => "Long Name",
#         :active => false,
#         :college_id => 1,
#         :data => "MyText"
#       )
#     ])
  end

  it "renders a list of insurance_companies" do
    render
    assert_select "tr>td", :text => "Short Name".to_s, :count => 2
    assert_select "tr>td", :text => "Long Name".to_s, :count => 2
    assert_select "tr>td>i.fa.fa-times", 2 #replace false
  end
end
