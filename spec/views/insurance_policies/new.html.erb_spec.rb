require 'rails_helper'

RSpec.describe "insurance_policies/new", :type => :view do
  before(:each) do
    assign(:insurance_policy, InsurancePolicy.new(
      :insurance_type => 1,
      :company_id => 1,
      :policy_no => "MyString",
      :college_id => 1,
      :data => "MyText"
    ))
  end

  it "renders new insurance_policy form" do
    render

    assert_select "form[action=?][method=?]", insurance_policies_path, "post" do

      assert_select "input#insurance_policy_insurance_type[name=?]", "insurance_policy[insurance_type]"

      assert_select "input#insurance_policy_company_id[name=?]", "insurance_policy[company_id]"

      assert_select "input#insurance_policy_policy_no[name=?]", "insurance_policy[policy_no]"

      assert_select "input#insurance_policy_college_id[name=?]", "insurance_policy[college_id]"

      assert_select "textarea#insurance_policy_data[name=?]", "insurance_policy[data]"
    end
  end
end