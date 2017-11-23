require 'rails_helper'

RSpec.describe "campus/address_books/edit", :type => :view do
  before(:each) do
    @college=FactoryGirl.create(:college)
    @address_book=FactoryGirl.create(:address_book, phone: '1234567890', fax: '1234567891', mail: 'external_co1@example.com', web: 'http://www.example.com', address: 'this is address line')
    @staff_user=FactoryGirl.create(:staff_user, college_id: @college.id)
    sign_in(@staff_user)
  end

  it "renders the edit address_book form" do
    render :template => 'campus/address_books/edit'

    assert_select "form[action=?][method=?]", campus_address_book_path(@address_book), "post" do
      
      assert_select "input#address_book_name[name=?]", "address_book[name]"
      assert_select "input#address_book_shortname[name=?]", "address_book[shortname]"
      assert_select "input#address_book_phone[name=?]", "address_book[phone]"
      assert_select "input#address_book_fax[name=?]", "address_book[fax]"
      assert_select "input#address_book_mail[name=?]", "address_book[mail]"
      assert_select "input#address_book_web[name=?]", "address_book[web]"
      assert_select "textarea#address_book_address[name=?]", "address_book[address]"
      
    end
  end
end
