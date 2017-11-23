require 'rails_helper'

RSpec.describe "campus/address_books/index", :type => :view do
  before do
    admin_user=FactoryGirl.create(:admin_user)
    sign_in(admin_user)
    @college=FactoryGirl.create(:college)
    @contact1=FactoryGirl.create(:address_book, college_id: @college.id)
    @contact2=FactoryGirl.create(:address_book, college_id: @college.id)
    search=AddressBook.search(params[:q])
    @address_books=search.result.page(params[:page]).per(5)
  end

  it "renders a list of contacts" do
#     render
    render :template => 'campus/address_books/index', :layout => false
    puts "#{@contact1.name}~ #{@contact1.shortname}"
    assert_select "h1", :text => I18n.t('campus.address.title'), :count => 1
    assert_select "th", :text => I18n.t('campus.address.name'), :count => 1
    assert_select "th", :text => I18n.t('campus.address.shortname'), :count => 1
    assert_select "th", :text => I18n.t('campus.address.address'), :count => 1
    assert_select "th", :text => I18n.t('campus.address.internet'), :count => 1
    assert_select "td", :text => @contact1.name, :count => 1
    assert_select "td", :text => @contact2.name, :count => 1
    assert_select "td>a", 2
    assert_select "td>a", :text => @contact1.name, :count => 1
    assert_select "td>a", :text => @contact2.name, :count => 1
    
#     TODO - below
#     should have_link(@contact1.shortname), href: edit_campus_address_book_path(@contact1.id) + "?locale=en"
#     
#     it { should have_link(@contact.name), href: campus_address_book_path(@contact) + "?locale=en" }
    
  end
end

# it { should have_selector('h1', text: 'List of Bulletins') }
#     it { should have_selector('th>a', text: 'Headline') }
#     it { should have_selector('th', text: 'Content') }
#     it { should have_selector('th', text: 'Posted By') }
#     it { should have_selector('th', text: 'Publish Date') }
#     it { should have_link(@bulletin1.headline), href: bulletins_path(@bulletin1) + "?locale=en" }
#     assert_select "tr>td>i.fa.fa-times", 2
