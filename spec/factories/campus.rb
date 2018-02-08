FactoryGirl.define do
  
  # Events  
  factory :event do
    sequence(:eventname) { |n| "eventname_#{n}" }
    end_at {Time.at(rand * Time.now.to_f)}
    start_at {Time.at(rand * Time.now.to_f)}
    location {"location_name"}
    association :staff, factory: :basic_staff
    officiated {"random name"}
    participants {"random participant"}
  end
  
  factory :document do
    sequence(:serialno) { |n| "serial_#{n}" }
    sequence(:refno) { |n| "refno_#{n}" }
    sequence(:title) { |n| "title_#{n}" }
    sequence(:from) { |n| "from_#{n}" }
    distribution_type 1
    category { Array(1..5).sample }
    association :college, factory: :college
    association :stafffilled, factory: :basic_staff
#     association :preparedby, factory: :basic_staff
#     association :cc1staff, factory: :basic_staff
#     association :cofile, factory: :cofile

#     ref: https://robots.thoughtbot.com/aint-no-calla-back-girl
    after(:create) {|document| create(:circulation, document: document)}
  end
  
  factory :circulation do
    association :staff, factory: :basic_staff
    association :document, factory: :document
  end
  
  factory :cofile do
    sequence(:cofileno) {|n| "Cofile No #{}"} 
    sequence(:name) { |n| "Cofile Name #{n}" }
    location "Bilik fail 1"
    onloan true
    onloandt { Date.today.yesterday }
    onloanxdt { Date.today }
    association :owner, factory: :basic_staff
    association :borrower, factory: :basic_staff
    association :college, factory: :college
  end
  
  factory :address_book do
    sequence(:name) { |n| "external_co_#{n}" }
    sequence(:shortname) { |n| "ext_co_#{n}" }
  end

  factory :bulletin do
    headline {"Headline"}
    content {"this is content"}
    association :staff, factory: :basic_staff
    publishdt {Time.at(rand * Time.now.to_f)}
  end
  
  factory :college do
     code "amsas"
     name "Kolej Satu"
     data {{ library_email: "testing@example.com", library_pwd: "mypassword"}}
     #data {{ foo: "foobar", baz: "baff" }}
   end
   
  factory :page do
    name {"home"}
    title {"Homepage"}
    association :college, factory: :college
    navlabel {"aaa"}
    position 1
#     c=Page.create(name: 'about', title: 'About', navlabel: 'aaa', position: 1)
  end
  
  factory :group do
    sequence(:name) {|n| "Some Name #{n}"}
    description {"Some Description"}
    members {{user_ids: ["1", "2", "3"]}}
    association :college, factory: :college
    data {"Some string" }
  end
  
  #Each msg must contains: 1)conversation, 2)notification, 3)sender_mailboxer & 4)receiver_mailboxer
  factory :mailboxer_conversation, :class => "Mailboxer::Conversation" do
    sequence(:subject) {|n| "Subject #{n}"}
    after(:create) {|mailboxer_conversation| create(:mailboxer_notification, conversation_id: mailboxer_conversation.id)}
  end
  
  factory :mailboxer_notification, :class => "Mailboxer::Notification" do
    type {"Mailboxer::Message"}
    body{"Some string"}
    sequence(:subject) {|n| "Subject #{n}"}
    association :sender, factory: :staff_user #original sender (first) (sender_type="User" & sender_id=user.id)
    draft false
    global false
    after(:create) {|mailboxer_notification| create(:receiver_mailboxer, notification_id: mailboxer_notification.id)}
    after(:create) {|mailboxer_notification| create(:sender_mailboxer, notification_id: mailboxer_notification.id, receiver: mailboxer_notification.sender)}
  end
  
  factory :mailboxer_receipt, :class => "Mailboxer::Receipt" do    
    is_read {rand(2) == 1}
    trashed false # {rand(2) == 1}
    deleted false #{rand(2) == 1}
    association :receiver, factory: :staff_user #(receiver_type="User" & receiver_id=user.id)
    
    factory :sender_mailboxer do
      mailbox_type {"sentbox"}
    end
    
    factory :receiver_mailboxer do
      mailbox_type {"inbox"}
    end
  end
  
  factory :mailbox do
  end
  
  factory :visitor do
    sequence(:name) {|n| "Visitor #{n}"}
    icno {(0...12).map {rand(10).to_s}.join }
    association :rank, factory: :rank
    association :title, factory: :title
    association :college, factory: :college
    association :address_book, factory: :address_book
    corporate {true}
    sequence(:department) {|n| "Department #{n}"}
    phoneno {(0...10).map {rand(10).to_s}.join }
    hpno {(0...10).map {rand(10).to_s}.join }
    email { |n| "visitor#{n}@example.com" }
    expertise {"My expertise"}
  end
  
  factory :insurance_company do
    sequence(:short_name) {|n| "Short Name #{n}"}
    sequence(:long_name) {|n| "Long Name #{n}"}
    active {rand(2) == 1}
    association :college, factory: :college
    data "My Text" #{"Some string" }
  end
  
  factory :bank do
    association :college, factory: :college
    sequence(:long_name) {|n| "Bank long name #{n}"}
    sequence(:short_name) {|n| "Bank short name #{n}"}
  end
  
  factory :kin do
    kintype_id 4 #{[1,2,3,4,5,9,11,12,13,14,98,99].sample}
    sequence(:name) {|n| "Kin name #{n}"}
    kinbirthdt "1990-01-01"
    phone "12345678"
    kinaddr "Kin Address"
    profession "Kin Profession"
    mykadno "Kin Mykadno"
    factory :staff_kin do
      association :staff, factory: :basic_staff
    end
#     factory :student_kins do
#     end
  end
  
  factory :location do
    association :college, factory: :college
    association :administrator, factory: :basic_staff
    factory :building do
      ancestry_depth 0 #root location
      sequence(:code) {|n| "B#{n}"}
      factory :admin_building do #education
	lclass 1
	sequence(:name) {|n| "Blok #{n}"} #Pusat Latihan (code: PL)
      end
      factory :student_residence do
	lclass 4
	sequence(:name) {|n| "Blok #{n}"} #Blok Tok Gajah (Asas pegawai) (code: BTG)
      end
      factory :staff_residence do
	lclass 1
	sequence(:name) {|n| "Apartment #{n}"} #Apartment F1 (code: AF)
      end
    end
    
    factory :floor do
      ancestry_depth 1
      lclass 2
      sequence(:name) {|n| "Floor #{n}"}
      sequence(:code) {|n| "#{n}F"}
      factory :admin_floor do
	association :parent, factory: :admin_building
      end
      factory :student_floor do
	association :parent, factory: :student_residence
      end
      factory :staff_floor do
	association :parent, factory: :staff_residence
      end
    end
    
    factory :staff_unit do
      ancestry_depth 2
      lclass 3
      typename 1
      sequence(:code) {|n| "0#{n}"}
      sequence(:name) {|n| "House #{n}"} #Rumah Staf 1 (code: 01)
      association :parent, factory: :staff_floor
    end
    
    factory :room do
      ancestry_depth 2
      lclass 3
      typename 6
      sequence(:code) {|n| "0#{n}"}
      sequence(:name) {|n| "Room #{n}"}  #Bilik Kuliah (code: BK-1), Bilik 106 (code: B106)
      factory :admin_room do                                                             
        association :parent, factory: :admin_floor
      end
      factory :student_room do
        association :parent, factory: :student_floor
      end
    end
    
    factory :bed do
      ancestry_depth 3
      lclass 3
      sequence(:code) {|n| "0#{n}"}
      sequence(:name) {|n| "Bed #{n}"} 
      association :parent, factory: :student_room
      factory :male_bed do
	typename 8
      end
      factory :female_bed do
	typename 2
      end

    end
    # NOTE 
    #staff_unit > staff_floor > staff_residence
    #admin_room > admin_floor > admin_building
    #male_bed/female_bed > student_room > student_floor > student_residence
  end
  
end
