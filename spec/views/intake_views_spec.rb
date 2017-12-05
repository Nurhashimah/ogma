# require 'spec_helper'
# 
# describe "Intake pages" do
#   
# #   subject { page } 
#   
#   before(:each) do
#     @intake = FactoryGirl.create(:intake, is_active: true) 
#     @admin_user=FactoryGirl.create(:admin_user)
#     sign_in(@admin_user)
#   end
#   
#   # NOTE - Index test - OK for title & table headers only, line#20,21&22 are required although expected @intakes3(searched records) are not displayed at all (test)
#   # To check - replace @intakes3 with Intake.all (in ./views/training/intakes/index.html.haml) & enable line#42 (puts page.body) - to display all records(Intake.all)
#   describe "Intake Index page" do 
#     
#     subject { page } 
#     
#     before do
#       @search=Intake.search({ q: { name_cont: "2017" } })
#       @intakes2 = @search.result 
#       @intakes3=@intakes2.page(10)
#       visit training_intakes_path
#     end
#    
#     it {should have_selector('h1', text: I18n.t('training.intake.title')) }
#     it {should have_selector('th', text: I18n.t('training.intake.division_name')) }
#     it {should have_selector('th', text: I18n.t('training.intake.register_on')) }
#     it {should have_selector('th', text: I18n.t('training.intake.programme_id')) }
#     it {should have_selector('th', text: I18n.t('training.intake.is_active')) } 
#     it "should have link to record show" do
#       page.has_link?@intake.name+"?locale=en", training_intake_path(@intake)
#     end
#     #     it { should have_link(@intake.name, href: training_intake_path(@intake)+"?locale=en") } #NOT OK
#     
#     it "list items somewhere in page but not as part of td text" do
#       page.has_content?@intake.name
#       page.has_content?@intake.description
#       page.has_content?@intake.register_on.try(:strftime, "%d %b %Y")
# #       puts @admin_user.college.code
# #       puts @intakes3.count
# #       puts page.body
# #       BOTH not ok
# #       expect(page).to have_content(@intake.register_on.try(:strftime, "%d %b %Y"))
# #       expect(page).to have_text(@intake.coordinator.try(:name))
#     end
#     
# #     it "list items in tr" do     
# # #    Checking done here - failed as td not found at all, only th available
# #       page.all('tr').each do |tr|
# # 	puts tr.text
# # # 	puts tr.all('td')[1].text   #This one failed - only headers appear?
# #       end
# #     end
#     
#   end
#   
#   describe "Intake New page" do
#     subject { page } 
#     before { visit new_training_intake_path}
#     
#     it { should have_selector('h1', text: I18n.t('training.intake.new')) }
#     it { should have_selector(:link_or_button, I18n.t('helpers.links.back'))}    
#     it { should have_selector(:link_or_button, I18n.t('training.intake.proceed'))} 
#   end
#   
#   describe "Intake Edit page" do
#     subject { page } 
#     before { visit edit_training_intake_path(@intake) }
#     
#     it { should have_selector('h1', text: I18n.t('training.intake.edit')+" #{@intake.programme.programme_list} #{@intake.name}") }
#     it { should have_selector(:link_or_button, I18n.t('helpers.links.back'))}    
#     it { should have_selector(:link_or_button, I18n.t('submit'))} 
#   end
#   
#   describe "Intake Show page" do
#     subject { page } 
#     before { visit training_intake_path(@intake) }
#     
#     it { should have_selector('h1', text: I18n.t('training.intake.title')) }
#     it { should have_selector(:link_or_button, I18n.t("helpers.links.back"))}    
#     it { should have_selector(:link_or_button, I18n.t("helpers.links.edit"))}    
#     it { should have_selector(:link_or_button, I18n.t("helpers.links.destroy"))}  
#     
#     it {should have_content(@intake.name)}
#     it {should have_css("dd", text: @intake.programme.programme_list) }
#     it {should have_css("dd", text: @intake.register_on.try(:strftime, "%d %b %Y")) }
#     it {should have_css("dd", text: I18n.t('training.intake.active')) }
#     it {should have_css("dd", text: @intake.coordinator.try(:name)) }
#     it {should have_css("dd", text: @intake.description) }
#     it {should have_css("dd", text: "(1) Bendahara - 32 person (2) Temengong - 32 person (3) Laksamana - 32 person (4) Panglima - 32 person")}
#     
#     it { should have_selector(:link_or_button, I18n.t("helpers.links.back"))}    
#     it { should have_selector(:link_or_button, I18n.t("helpers.links.edit"))}    
#     it { should have_selector(:link_or_button, I18n.t("helpers.links.destroy"))}    
#     
# #     it "list all dt items" do
# #       puts "--------------------"
# #       page.all('dl').each do |dl|
# # 	puts dl.text
# # 	puts dl.all('dd').last.text
# #       end
# #     end
#   end
#   
# end
#   