require 'rails_helper'

RSpec.describe "insurance_companies/show", :type => :view do
  before(:each) do
    @insurance_company=FactoryGirl.create(:insurance_company, active: false)
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Short Name/)
    expect(rendered).to match(/Long Name/)
    expect(rendered).to match(/false/)
  end
end
