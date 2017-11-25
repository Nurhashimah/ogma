require 'rails_helper'

RSpec.describe "events/show", :type => :view do
  before(:each) do
    @admin_user=FactoryGirl.create(:admin_user)
    sign_in(@admin_user)
    @college=FactoryGirl.create(:college)
    @event=FactoryGirl.create(:event, eventname: "eventname_1", start_at: "2017-01-01 08:00:00", end_at: "2017-01-01 18:00:00", createdby: @admin_user.userable_id)
  end

  it "renders attributes in dl>dt & dd" do
    render
    assert_select "h1", :text => I18n.t('events.ced'), :count => 1
    expect(rendered).to match(/Eventname 1/) # NOTE - titleize
    expect(rendered).to match(/01 Jan 17, Sun, 08:00AM/)
    expect(rendered).to match(/01 Jan 17, Sun, 06:00PM/)
    expect(rendered).to match(/location_name/)
    expect(rendered).to match(/random participant/)
    expect(rendered).to match(/random name/)
    assert_select "dd", :text => @event.staff.name
  end
end

