require 'rails_helper'

RSpec.describe "groups/new", :type => :view do
  before(:each) do
    assign(:group, Group.new(
      :name => "MyString",
      :description => "MyString",
      :members => "MyText"
    ))
  end

  it "renders new group form" do
    render

    assert_select "form[action=?][method=?]", groups_path, "post" do

      assert_select "input#group_name[name=?]", "group[name]"

      assert_select "input#group_description[name=?]", "group[description]"

      assert_select "textarea#group_members[name=?]", "group[members]"
    end
  end
end
