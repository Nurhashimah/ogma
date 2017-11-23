require 'rails_helper'

RSpec.describe "insurance_companies/edit", :type => :view do
  before(:each) do
    @insurance_company=FactoryGirl.create(:insurance_company, active: false)
  end

  it "renders the edit insurance_company form" do
    render

    assert_select "form[action=?][method=?]", insurance_company_path(@insurance_company), "post" do

      assert_select "input#insurance_company_short_name[name=?]", "insurance_company[short_name]"

      assert_select "input#insurance_company_long_name[name=?]", "insurance_company[long_name]"

      assert_select "input#insurance_company_active[name=?]", "insurance_company[active]"
              
    end
  end
end
