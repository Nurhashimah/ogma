require 'rails_helper'

RSpec.describe "events/new", :type => :view do
  before(:each) do
    @admin_user=FactoryGirl.create(:admin_user)
    sign_in(@admin_user)
    @college=FactoryGirl.create(:college)
    @event=FactoryGirl.build(:event, eventname: "eventname_1", start_at: "2017-01-01 08:00:00", end_at: "2017-01-01 18:00:00", createdby: @admin_user.userable_id)
  end

  it "renders attributes in dl>dt & dd" do
    render
    
    assert_select "form[action=?][method=?]", events_path, "post" do
      
      assert_select "input#event_eventname[name=?]", "event[eventname]"
      assert_select "input#event_start_at[name=?]", "event[start_at]"
      assert_select "input#event_end_at[name=?]", "event[end_at]"
      assert_select "input#event_location[name=?]", "event[location]"
      assert_select "textarea#event_participants[name=?]", "event[participants]"
      assert_select "input#event_officiated[name=?]", "event[officiated]"
      assert_select "select#event_createdby[name=?]", "event[createdby]"
      
    end
  end
end