require 'rails_helper'

RSpec.describe "bulletins/edit", :type => :view do
  before(:each) do
    @bulletin=FactoryGirl.create(:bulletin)
  end

  it "renders the edit bulletin form" do
    render

    assert_select "form[action=?][method=?]", bulletin_path(@bulletin), "post" do
      assert_select "input#bulletin_headline[name=?]", "bulletin[headline]"
      assert_select "textarea#bulletin_content[name=?]", "bulletin[content]"
      assert_select "select#bulletin_postedby_id[name=?]", "bulletin[postedby_id]"
      assert_select "input#bulletin_publishdt[name=?]", "bulletin[publishdt]"
      assert_select "input#bulletin_data[name=?]", "bulletin[data]"
      
    end
  end
end
