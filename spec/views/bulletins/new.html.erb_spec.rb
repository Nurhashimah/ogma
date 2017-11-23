require 'rails_helper'

RSpec.describe "bulletins/new", :type => :view do
  
  before(:each) do

    @admin_user=FactoryGirl.create(:admin_user)
    sign_in(@admin_user)
    @bulletin=FactoryGirl.create(:bulletin)
    
#     @basic_staff=FactoryGirl.create(:basic_staff)
#     @college=FactoryGirl.create(:college)
#     assign(:bulletin, Bulletin.new(
#       :headline => "Headline",
#       :postedby_id => @basic_staff.id,
#       :college_id => @college.id
#     ))
  end
  it "renders new bulletin form" do
    render
     
     assert_select "form[action=?][method=?]", bulletins_path, "post" do
      assert_select "input#bulletin_headline[name=?]", "bulletin[headline]"
      assert_select "textarea#bulletin_content[name=?]", "bulletin[content]"
      assert_select "select#bulletin_postedby_id[name=?]", "bulletin[postedby_id]"
      assert_select "input#bulletin_publishdt[name=?]", "bulletin[publishdt]"
      assert_select "input#bulletin_data[name=?]", "bulletin[data]"
      assert_select "input#bulletin_college_id[name=?]", "bulletin[college_id]"

    end
  end
end
