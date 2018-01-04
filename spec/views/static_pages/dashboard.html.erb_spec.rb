require 'rails_helper'
include Notifications
# include MailboxerController, ConversationsController
# http://jamestansley.com/?p=100
# private
# 
# def mailbox
#  @mailbox ||= current_user.mailbox
# end

# >> Mailboxer::Conversation
# => Mailboxer::Conversation(id: integer, subject: string, created_at: datetime, updated_at: datetime, college_id: integer, data: string)


RSpec.describe "static_pages/dashboard", :type => :view do
  
  before(:each) do
    @admin_user=FactoryGirl.create(:admin_user)
    sign_in(@admin_user)
    @bulletins = Bulletin.order(publishdt: :desc).limit(10)
    
  end

  it "renders dashboard items" do
    render
    
    assert_select "a[href=?]", events_path, :text => I18n.t('dashboard.events')


  end
end