require 'rails_helper'

RSpec.describe "documents/index", :type => :view do
  
  before(:each) do 
    @admin_user=FactoryGirl.create(:admin_user)
    sign_in(@admin_user)
    @document1 = FactoryGirl.create(:document, stafffiled_id: @admin_user.userable_id, distribution_type: 1)
    @document2 = FactoryGirl.create(:document, stafffiled_id: @admin_user.userable_id, distribution_type: 1)
    @search=Document.search(params[:q])
    @documents=@search.result
    @documents_pagi=@documents.page(params[:page]).per(5)
  end

  it "renders a list of documents" do
    render
    
    assert_select "h1", :text => I18n.t('document.list_of_document')
    assert_select "a", :text => I18n.t('actions.new')
    assert_select "a", :text => I18n.t('actions.search')
    assert_select "a", :text => I18n.t('actions.print')
    assert_select "a[href=?]", document_report_documents_path(params.merge(format: 'pdf' )), :text => I18n.t('document.generate_report'), :count => 1

    assert_select "tr>th", :text => ""
    assert_select "th>a", :text => I18n.t('document.serial_no')
    assert_select "th>a", :text => I18n.t('document.ref_no')
    assert_select "th>a", :text => I18n.t('document.category')
    assert_select "th>a", :text => I18n.t('document.title2')      
    assert_select "th>a", :text => I18n.t('document.letter_date') 
    assert_select "th>a", :text => I18n.t('document.received_date') 
    assert_select "th>a", :text => I18n.t('document.from') 
    assert_select "th>a", :text => "Status / "+I18n.t('document.circulation_date')
    assert_select "th", :text => I18n.t('document.action_notifications')
    assert_select "th>a", :text => I18n.t('document.file_closed')
    
    assert_select "tr>td>i.fa.fa-envelope-o", 2 # 1st column
    assert_select "td", :text => @document1.serialno
    assert_select "td", :text => @document2.serialno
    assert_select "td>a[href=?]", document_path(@document1), :text => @document1.refno
    assert_select "td>a[href=?]", document_path(@document2), :text => @document2.refno
    assert_select "td", :text => @document1.render_document
    assert_select "td", :text => @document2.render_document
    assert_select "td", :text => @document1.title
    assert_select "td", :text => @document2.title
    assert_select "td", :text => @document1.letterdt.try(:strftime, '%d-%m-%Y')
    assert_select "td", :text => @document2.letterdt.try(:strftime, '%d-%m-%Y')
    assert_select "td", :text => @document1.letterxdt.try(:strftime, '%d-%m-%Y')
    assert_select "td", :text => @document2.letterxdt.try(:strftime, '%d-%m-%Y')
    assert_select "td", :text => @document1.from
    assert_select "td", :text => @document2.from
    assert_select "td>i.fa.fa-times", 4 #2 ea for :, actions/notifications & file_close
     
  end
end
