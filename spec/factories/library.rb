FactoryGirl.define do

  factory :book do
    sequence(:isbn) { |n| "isbn_#{n}" }
    sequence(:title) { |n| "My title_#{n}" }
    language {['BM','BI'].sample}
#     after(:create) {|book| accession=[create(:accession, book: book)]}
  end

  factory :accession do
    sequence(:accession_no) { |n| "0#{n}" }
    association :book, factory: :book
  end
  
  factory :librarytransaction do
    association :accession, factory: :accession
    checkoutdate '2017-11-13'
    returnduedate '2017-11-30'
    ru_staff true
    association :staff, factory: :basic_staff
    association :libcheckout_by, factory: :basic_staff
#     association :college, factory: :college
  end
  
end

#   Accession.create(accession_no: '01', book_id: 1)
# Book.create(isbn: 'isbn1', title: 'My title', language: 'BM')
# Librarytransaction.create(accession_id: 3, checkoutdate: '2017-11-13', returnduedate: '2017-11-30', ru_staff: true, staff_id: 1, accession_acc_book: "01 My title", libcheckout_by: 2, college_id: 1)

# 
#   before(:each) do
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
#    end