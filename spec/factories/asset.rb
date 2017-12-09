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

  factory :stationery do
    #category "some_name"
    #code "some_code"
    sequence(:category) { |n| "category#{n}" }
    unittype "some unit type"
    sequence(:code) { |n| "code#{n}" }
  end
  
  factory :asset_placement do
    association :location, factory: :location
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

end
