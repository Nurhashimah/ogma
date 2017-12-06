require 'rails_helper'

RSpec.describe "documents/edit", :type => :view do
  before(:each) do 
    @admin_user=FactoryGirl.create(:admin_user)
    sign_in(@admin_user)
    @document = FactoryGirl.create(:document, stafffiled_id: @admin_user.userable_id, distribution_type: 1)
  end

  it "renders the edit document form" do
    render

    assert_select "h1", :text => "#{I18n.t('helpers.links.edit')}\n#{@document.refno} :  #{@document.title.capitalize}"
    
#     assert_select "form[action=?][method=?]", documents_path, "post" do
    
    assert_select "form[action=?][method=?]", document_path(@document), "post" do   
      assert_select "input#document_serialno[name=?]", "document[serialno]"
      assert_select "input#document_refno[name=?]", "document[refno]"
      assert_select "input#document_title[name=?]", "document[title]"
      assert_select "select#document_category[name=?]", "document[category]"
      assert_select "input#document_distribution_type_1[name=?]", "document[distribution_type]"
      assert_select "input#document_distribution_type_2[name=?]", "document[distribution_type]"
      assert_select "input#document_letterdt[name=?]", "document[letterdt]"
      assert_select "input#document_letterxdt[name=?]", "document[letterxdt]"
      assert_select "input#document_from[name=?]", "document[from]"
      assert_select "select#document_stafffiled_id[name=?]", "document[stafffiled_id]"
      assert_select "input#document_prepared_by[name=?]", "document[prepared_by]"
      assert_select "select#document_file_id[name=?]", "document[file_id]"
      assert_select "input#document_data[name=?]", "document[data]"
      assert_select "select#document_cc1staff_id[name=?]", "document[cc1staff_id]"
      assert_select "input#document_cc1date[name=?]", "document[cc1date]"
      assert_select "select#document_recipients[name=?]", "document[recipients][]"
      assert_select "input#document_closed[name=?]", "document[closed]"
      
      # buttons links
      assert_select "a[href=?]", document_path(@document), {text: I18n.t("helpers.links.back")}
      assert_select "input.btn.btn-primary[name=?][type=?][value=?]", "commit", "submit", I18n.t('update')
    end
  end
end
