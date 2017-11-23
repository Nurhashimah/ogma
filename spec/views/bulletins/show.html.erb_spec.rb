require 'rails_helper'

RSpec.describe "bulletins/show", :type => :view do
  before(:each) do
    @college=FactoryGirl.create(:college)
    @postedby=FactoryGirl.create(:basic_staff)
    @bulletin=FactoryGirl.create(:bulletin, postedby_id: @postedby.id, college_id: @college.id)
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Headline/)
    expect(rendered).to match(/this is content/)
    expect(rendered).to match("#{@bulletin.staff.staff_with_rank}")
  end
end
