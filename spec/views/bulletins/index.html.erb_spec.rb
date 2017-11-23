require 'rails_helper'

RSpec.describe "bulletins/index", :type => :view do
  before(:each) do
    @admin_user=FactoryGirl.create(:admin_user)
    sign_in(@admin_user)
    @college=FactoryGirl.create(:college)
    @bulletins1=FactoryGirl.create(:bulletin)
    @bulletins2=FactoryGirl.create(:bulletin)
    @search=Bulletin.search(params[:q])
    @bulletins=@search.result.page(params[:page]).per(5)
  end

  it "renders a list of buletins" do
    render
    assert_select "h1", :text => "List of Bulletins", :count => 1
    assert_select "th>a", :text => "Headline", :count => 1
    assert_select "th>a", :text => "Content", :count => 1
    assert_select "th>a", :text => "Posted By", :count => 1
    assert_select "th>a", :text => "Publish Date", :count => 1
    assert_select "tr>td>a", :text => "Headline", :count => 2
  end
end

# it { should have_selector('h1', text: 'List of Bulletins') }
#     it { should have_selector('th>a', text: 'Headline') }
#     it { should have_selector('th', text: 'Content') }
#     it { should have_selector('th', text: 'Posted By') }
#     it { should have_selector('th', text: 'Publish Date') }
#     it { should have_link(@bulletin1.headline), href: bulletins_path(@bulletin1) + "?locale=en" }
#     assert_select "tr>td>i.fa.fa-times", 2


