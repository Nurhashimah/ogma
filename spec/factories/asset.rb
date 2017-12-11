FactoryGirl.define do

  # Assets
  factory :asset do
    sequence(:assetcode) { |n| "1#{n}" }
  end

  factory :fixed_asset, class: 'Asset' do
    sequence(:assetcode) { |n| "KKM/BPL/010619/H/10/1#{n}" }
    assettype 1
  end

  factory :inventory, class: 'Asset'  do
    sequence(:assetcode) { |n| "KKM/BPL/010619/I/10/1#{n}" }
    assettype 2
  end


  factory :asset_defect do
    association :asset, factory: :fixed_asset
    association :reporter, factory: :basic_staff_with_position
    association :processor, factory: :basic_staff_with_position
    association :confirmer, factory: :basic_staff_with_position
    process_type "repair" #{["repair", "dispose"].sample}
    processed_on { Date.today }
    is_processed true #{rand(2) == 1}
    recommendation "Send for repair"
  end

  factory :asset_disposal do
    association :asset, factory: :fixed_asset
    current_value 1
  end

  # NOTE - 11Dec2017 for has many relationship - 2 method available: refer stationery (method1), asset_placement / maint (method 2) & it's usage in views tests
  factory :stationery do
    association :college, factory: :college
    sequence(:code) { |n| "code#{n}" }
    sequence(:category) { |n| "category#{n}" }
    unittype "some unit type"
    maxquantity 500
    minquantity 10
    
    #remark between these lines - start(for method2)
    after(:create) do |stationery| 
      stationery.stationery_adds = [create(:stationery_add, stationery: stationery)]
    end
    after(:create) do |stationery| 
      stationery.stationery_uses = [create(:stationery_use, stationery: stationery)]
    end
    #remark between these lines - end (for method2)
  end
  
  factory :stationery_add do
    association :college, factory: :college
#     association :stationery, factory: :stationery #unremark this line (for method 1)
    sequence(:lpono) {|n| "Lpo No #{n}"}
    sequence(:document) { |n| "Supplier #{n}"}
    quantity 100
    unitcost 1.0
    received { Date.today-2.days }  
  end
  
  factory :stationery_use do
    association :college, factory: :college
#     association :stationery, factory: :stationery #unremark this line (for method 1)
    association :issuesupply, factory: :basic_staff_with_rank
    association :receivesupply, factory: :basic_staff_with_rank
    issuedate { Date.today }
    quantity 1
  end
  
  factory :asset_placement do
    association :location, factory: :admin_room          #OR student_room OR staff_unit
    association :staff, factory: :basic_staff
    quantity 1
    reg_on {Date.today}
    factory :fixed_asset_placement do
      association :asset, factory: :fixed_asset
    end
    factory:inventory_placement do
      association :asset, factory: :inventory
    end
  end
  
  factory :maint do
    association :college, factory: :college
    association :asset, factory: :fixed_asset
    association :maintainer, factory: :address_book
    sequence(:details) {|n| "Maintainance details line #{n}"}
    maintcost 250.00
    workorderno "po11229"
  end

end
