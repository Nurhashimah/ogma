require 'spec_helper'

describe Book do

  before { @book = FactoryGirl.create(:book)}

  subject { @book }
  
  it { should respond_to(:isbn) }
  it { should respond_to(:title) }
  it { should respond_to(:language) }
  it { should respond_to(:accessions) }
  
  it { should be_valid }
  
  describe "when isbn is not present" do
    before { @book.isbn = nil }
    it { should_not be_valid }
  end
  
  describe "when title is not present" do
    before { @book.title = nil }
    it { should_not be_valid }
  end
  
  describe "when language is not present" do
    before { @book.language = nil }
    it { should_not be_valid }
  end
  
  describe "when accession no is not present" do
#      REF:
#      b=Book.create(isbn: 'isbn_b', title: "My title", language: "BI", accessions_attributes: [{accession_no: "acc_2"}])

#     BOTH approach - OK
#     before { @book2=Book.create(isbn: 'isbn_b', title: "My title", language: "BI", accessions_attributes: [{accession_no: nil}]) }
    before {@book2=FactoryGirl.build(:book, accessions_attributes: [{accession_no: nil}])}
    subject { @book2 }
    it { should_not be_valid }
  
  end
  
  describe "when accessions not present" do
#     BOTH approach - OK
#     before { @book2=Book.create(isbn: 'isbn_b', title: "My title", language: "BI", accessions_attributes: []) }
    before {@book2=FactoryGirl.build(:book, accessions_attributes: [])}
    subject { @book2 }
    it { should_not be_valid }
  end
  
  describe "when accessions status is on loan (restrict it's removal)" do
    before do
      #https://stackoverflow.com/questions/22831923/possible-to-mark-associated-objects-to-delete
      #acc=Book.first.accessions_attributes={id: '16', _destroy: '1'}
      @accession=@book.accessions.first
      @accession.status=2 
      @book.accessions_attributes={id: @accession.id.to_s, _destroy: '1'}
    end
    it { should_not be_valid }
  end
  
  describe "when accessions status is weeding (restrict it's removal)" do
    before do
      @accession=@book.accessions.first
      @accession.status=3
      @book.accessions_attributes={id: @accession.id.to_s, _destroy: '1'}
    end
    it { should_not be_valid }
  end
  
  describe "when accessions status is reference (restrict it's removal)" do
    before do
      @accession=@book.accessions.first
      @accession.status=4
      @book.accessions_attributes={id: @accession.id.to_s, _destroy: '1'}
    end
    it { should_not be_valid }
  end
  
  describe "when isbn is not unique" do
    before do
      @book.isbn="isbn_1"
      @book2=FactoryGirl.build(:book, isbn: "isbn_1")
    end
    it { should_not be_valid }
  end
  
end