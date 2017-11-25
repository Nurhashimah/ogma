require 'rails_helper'

RSpec.describe "events/index", :type => :view do
  before(:each) do
    @admin_user=FactoryGirl.create(:admin_user)
    sign_in(@admin_user)
    @college=FactoryGirl.create(:college)
    @event1=FactoryGirl.create(:event)
    @event2=FactoryGirl.create(:event)
    @search=Event.search(params[:q])
    @events=@search.result.page(params[:page]).per(5)
  end

  it "renders a list of buletins" do
    render
    assert_select "h1", :text => I18n.t('events.list'), :count => 1
    assert_select "th>a", :text => I18n.t('events.sd'), :count => 1
    assert_select "th>a", :text => I18n.t('events.ed'), :count => 1
    assert_select "th>a", :text => I18n.t('events.loca'), :count => 1
    assert_select "th>a", :text => I18n.t('events.ob'), :count => 1
    assert_select "th>a", :text => I18n.t('events.cb'), :count => 1
    assert_select "tr>td>a", :count => 2
    assert_select "a[href=?]", event_path(@event1)
    assert_select "a[href=?]", event_path(@event2)
    expect(rendered).to match(/eventname/)
  end
end


