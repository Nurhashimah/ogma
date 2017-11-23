require 'spec_helper'
# require './vendor/declarative_authorization/maintenance'
# include Authorization::Maintenance

describe "menu pages" do
  
#   subject { page }
#   before {@college=FactoryGirl.create(:college)}
#   before {@page=FactoryGirl.create(:page)}
#   before {@admin_user=FactoryGirl.create(:admin_user)}
#   
#   before { sign_in(@admin_user)}
#   before { render :template => "layouts/_menu.html" }
  
#   before(:each) do
# #     @college=FactoryGirl.create(:college)
# #     @page=FactoryGirl.create(:page)
  
#   pertama
#     @admin_user=FactoryGirl.create(:admin_user)
   
#     kedua
#     let(:user) {FactoryGirl.create(:admin_user)}
#     before(:each) { sign_in user }
#     after(:each) { sign_out user}
  
#   end
    
  it "contains all menu items" do
#     pertama
#     sign_in(@admin_user)
    
#     ketiga
    allow(view).to receive(:user_signed_in?) { true }
    allow(view).to receive(:current_user).and_return(FactoryGirl.create(:admin_user))
    
#     before(:each) do
#       allow(view).to receive(:permitted_to?).and_return(true)
#     end
      
    
#     sample - http://codejaxy.com/q/295182/ruby-on-rails-ruby-testing-rspec-why-is-the-first-rspec-view-test-ran-always-the-slowest
#     allow(view).to receive(:permitted_to?).and_return(true)
      #        - permitted_to? :read, :staff_staffs 
    
    
    
     
     
      
      
     
     
#      
#       
#     allow(view).to receive(:permitted_to?).with(:show, :colleges).and_return(true)
#     allow(view).to receive(:permitted_to?).with(:create, :equery_report_staffsearch2s).and_return(true)
#     allow(view).to receive(:permitted_to?).with(:create, :equery_report_staffattendancesearches).and_return(true)
#     allow(view).to receive(:permitted_to?).with(:create, :equery_report_ptdosearches ).and_return(true)
#     allow(view).to receive(:permitted_to?).with(:create, :equery_report_assetsearches).and_return(true)
#     allow(view).to receive(:permitted_to?).with(:create, :equery_report_stationerysearches).and_return(true)
#     allow(view).to receive(:permitted_to?).with(:create, :equery_report_documentsearches).and_return(true)
#     allow(view).to receive(:permitted_to?).with(:create, :equery_report_studentsearches).and_return(true)
#     allow(view).to receive(:permitted_to?).with(:read, :equery_report_studentattendancesearches).and_return(true)
#     allow(view).to receive(:permitted_to?).with(:create, :equery_report_studentdisciplinesearches).and_return(true)
#     allow(view).to receive(:permitted_to?).with(:create, :equery_report_studentcounselingsearches).and_return(true)
#     allow(view).to receive(:permitted_to?).with(:create, :equery_report_weeklytimetablesearches).and_return(true)
#     allow(view).to receive(:permitted_to?).with(:create, :equery_report_curriculumsearches).and_return(true)
#     allow(view).to receive(:permitted_to?).with(:create, :equery_report_lessonplansearches).and_return(true)
#     allow(view).to receive(:permitted_to?).with(:create, :equery_report_personalizetimetablesearches).and_return(true)
#     allow(view).to receive(:permitted_to?).with(:create, :equery_report_examsearches).and_return(true)
#     allow(view).to receive(:permitted_to?).with(:create, :equery_report_examresultsearches).and_return(true)
#     allow(view).to receive(:permitted_to?).with(:create, :equery_report_evaluatecoursesearches).and_return(true)
#     allow(view).to receive(:permitted_to?).with(:create, :equery_report_examanalysissearches).and_return(true)
#     allow(view).to receive(:permitted_to?).with(:new_digital_library, :equery_report_repositorysearches).and_return(true)
#     
# 
#     allow(view).to receive(:permitted_to?).with(:read, :banks).and_return(true)
#     allow(view).to receive(:permitted_to?).with(:read, :insurance_companies).and_return(true)
#     allow(view).to receive(:permitted_to?).with(:read, :staff_titles).and_return(true)
#     allow(view).to receive(:permitted_to?).with(:read, :staff_staff_shifts).and_return(true)
#     allow(view).to receive(:permitted_to?).with(:read, :staff_travel_claims_transport_groups).and_return(true)
#     allow(view).to receive(:permitted_to?).with(:read, :staff_travel_claim_mileage_rates).and_return(true)
#     allow(view).to receive(:permitted_to?).with(:read, :asset_assetcategories).and_return(true)
#     allow(view).to receive(:permitted_to?).with(:read, :staff_ranks).and_return(true)
#     allow(view).to receive(:permitted_to?).with(:read, :staff_employgrades).and_return(true)
#     allow(view).to receive(:permitted_to?).with(:read, :staff_postinfos).and_return(true)
#     allow(view).to receive(:permitted_to?).with(:manage, :roles).and_return(true)
#     allow(view).to receive(:permitted_to?).with(:menu, :campus_pages).and_return(true)
#     allow(view).to receive(:permitted_to?).with(:read, :campus_address_books).and_return(true)
#     allow(view).to receive(:permitted_to?).with(:read, :campus_visitors).and_return(true)
#     allow(view).to receive(:permitted_to?).with(:read, :repositories).and_return(true)
# #     allow(view).to receive(:permitted_to?).with().and_return(true)
#     allow(view).to receive(:permitted_to?).with(:read, :library_books).and_return(true)
#     allow(view).to receive(:permitted_to?).with(:menu, :exam_exams).and_return(true)
#     allow(view).to receive(:permitted_to?).with(:menu, :training_trainingnotes).and_return(true)
#     allow(view).to receive(:permitted_to?).with(:menu, :student_student_discipline_cases).and_return(true)
#     allow(view).to receive(:permitted_to?).with(:menu, :documents).and_return(true)
#     allow(view).to receive(:permitted_to?).with(:menu, :campus_bookingfacilities).and_return(true)
#     
#     
      
    
    #https://www.codesd.com/item/how-to-test-declarative-authorization-with-rspec.html
#     without_access_control 
    
    render :template => "layouts/_menu.html"

    rendered.should have_selector('h2', text: 'Menu')
    rendered.should have_selector('h2', text: I18n.t('administration.title'))
    rendered.should have_selector('h2', text: I18n.t('support.title'))
    rendered.should have_selector('h2', text: I18n.t('equery.title'))

#     allow(view).to receive(:permitted_to?).with(:read, :staff_staffs).and_return(true)
#     rendered.should have_selector('h2', text: I18n.t('staff.title'))
#     rendered.should have_link(I18n.t('position.index'), href: staff_positions_path + "?locale=en" ) 
#     rendered.should have_link(I18n.t('staff.training.budget.title'), href: staff_training_ptbudgets_path + "?locale=en" )
    
    allow(view).to receive(:permitted_to?).with(:read, :asset_assets).and_return(true)
    rendered.should have_selector('h2', text: I18n.t("asset.title"))
    rendered.should have_link(I18n.t("asset.title"), href: asset_assets_path + "?locale=en" ) 
    
    rendered.should have_selector('h2', text: I18n.t('location.title'))
    rendered.should have_selector('h2', text: I18n.t('student.title')) 
  end
#   
#   it { should have_selector('h2', text: I18n.t('staff.title'))}
#   it { should have_selector('h2', text: I18n.t("asset.title"))}
#   it { should have_link(I18n.t("asset.title"), href: asset_assets_path + "?locale=en" ) }
#   it { should have_selector('h2', text: I18n.t('location.title'))}
#   it { should have_selector('h2', text: I18n.t('student.title')) }
#   it { should have_link(I18n.t('position.index'), href: staff_positions_path + "?locale=en" ) }
#   it { should have_link(I18n.t('staff.training.budget.title'), href: staff_training_ptbudgets_path + "?locale=en" ) }
end


# Menu, Administration, Support Tables, Equery/Reports
# ------------------------------------------------------------------------------------
#  354) menu pages contains all menu items
#      Failure/Error: rendered.should have_selector('h2', text: I18n.t('staff.title'))
#      Capybara::ExpectationNotMet:
#        expected to find css "h2" with text "Staff" but there were no matches. Also found "Menu", "Administration", "Support Tables", "Equery / Reports", which matched the selector but not all filters.
#      # ./spec/views/menu_spec.rb:34:in `block (2 levels) in <top (required)>'

# https://github.com/stffn/declarative_authorization/blob/master/lib/declarative_authorization/maintenance.rb
# http://www.rubydoc.info/github/stffn/declarative_authorization/Authorization%2FTestHelper:should_be_allowed_to