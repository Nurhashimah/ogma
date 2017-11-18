require 'spec_helper'

describe Librarytransaction do

  before(:all) do
#     @accessions=FactoryGirl.create(:accession) #will create 2 accessions + 1 book
    @librarytransaction=FactoryGirl.create(:librarytransaction) #1 trans+1 book+2 accessions
#     @librarytransaction2=FactoryGirl.create(:librarytransaction)
    
#     @book=Book.create(isbn: 'isbn12345678910a', title: 'My title', language: 'BM')
#     @accession= Accession.create(accession_no: '03', book_id: @book.id)
#     @accession2= Accession.create(accession_no: '04', book_id: @book.id)
#     @librarytransaction = Librarytransaction.create(
#       :accession_id => @accession.id,
#       :checkoutdate => '2017-11-13',
#       :returnduedate => '2017-11-30')
#     
#     @librarytransaction2 = Librarytransaction.create(
#       :accession_id => @accession2.id,
#       :checkoutdate => '2017-11-13',
#       :returnduedate => '2017-11-30')
   end
   
  subject { @librarytransaction }

  it { should respond_to(:accession_id) }
  it { should respond_to(:checkoutdate) }
  it { should respond_to(:returnduedate) }
  
  it { should be_valid }
  
  it "is invalid if book copy(same accession) is still on loan" do
    expect(FactoryGirl.build(:librarytransaction, accession_id: @librarytransaction.accession_id)).not_to be_valid
  end
  
#   it "is invalid when accession is not present" do
#     expect(FactoryGirl.build(:librarytransaction, accession_id: nil)).not_to be_valid
#   end
  
#   describe "when accession is not present" do
#     before {@librarytransaction.accession_id= nil}
#     it { should_not be_valid }
#   end
  
end