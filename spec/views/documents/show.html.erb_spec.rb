require 'rails_helper'

RSpec.describe "documents/show", :type => :view do
  before(:each) do 
    @admin_user=FactoryGirl.create(:admin_user)
    sign_in(@admin_user)
    @basic_staff_with_rank=FactoryGirl.create(:basic_staff_with_rank)
    @document = FactoryGirl.create(:document, stafffiled_id: @basic_staff_with_rank.id, distribution_type: 1, serialno: "1212", refno: "kpt-34", title: "My title")
  end

  it "renders attributes in <dl>" do
    render
    
    expect(rendered).to match(/1212/)
    expect(rendered).to match(/kpt-34/)
    expect(rendered).to match(/My title/)
    expect(rendered).to match("#{I18n.t('document.internal')}")
    assert_select "dd", text: @document.render_document
    assert_select "dd", text: @document.letterdt.try(:strftime, "%d %b %Y" )
    assert_select "dd", text: @document.letterxdt.try(:strftime, "%d %b %Y" )
    assert_select "dt", text: I18n.t('document.from')
    assert_select "dd", text: @document.from
    assert_select "dd", text: @document.stafffilled.staff_with_rank_position
    assert_select "dd", text: check_kin {@document.file_details} 
    
    #page - buttons / links
    assert_select "a[href=?]", documents_path, {text: "#{I18n.t("helpers.links.back")}" }
    assert_select "a[href=?]", edit_document_path(@document), {text: I18n.t("helpers.links.edit")}
    assert_select "a[href=?]", document_path(@document), {text: I18n.t("helpers.links.destroy")}

  end
end
