require 'rails_helper'

RSpec.describe "cofiles/new", :type => :view do
  
  before(:each) do
    @admin_user=FactoryGirl.create(:admin_user)
    sign_in(@admin_user)
    @cofile=FactoryGirl.build(:cofile)
    
#     @basic_staff=FactoryGirl.create(:basic_staff)
#     @college=FactoryGirl.create(:college)
#     assign(:cofile, Bulletin.new(
#       :headline => "Headline",
#       :postedby_id => @basic_staff.id,
#       :college_id => @college.id
#     ))
  end
  it "renders new cofile form" do
    render
     
     assert_select "form[action=?][method=?]", cofiles_path, "post" do
      assert_select "input#cofile_cofileno[name=?]", "cofile[cofileno]"
      assert_select "input#cofile_name[name=?]", "cofile[name]"
      assert_select "input#cofile_location[name=?]", "cofile[location]"
      assert_select "select#cofile_owner_id[name=?]", "cofile[owner_id]"
      assert_select "input#fileborrow[name=?]", "cofile[onloan]"
      assert_select "select#cofile_staffloan_id[name=?]", "cofile[staffloan_id]"
      assert_select "input#cofile_onloandt[name=?]", "cofile[onloandt]"
      assert_select "input#cofile_onloanxdt[name=?]", "cofile[onloanxdt]"
      
      # buttons links
      assert_select "a[href=?]", cofiles_path, {text: I18n.t("helpers.links.back")}      
      assert_select "input.btn.btn-primary[name=?][type=?][value=?]", "commit", "submit", I18n.t('create')

    end
    
    
  end
end
