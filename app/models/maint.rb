class Maint < ActiveRecord::Base
   belongs_to :college
   belongs_to :asset
   belongs_to :maintainer, :class_name => 'AddressBook'
end

# == Schema Information
#
# Table name: maints
#
#  asset_id      :integer
#  created_at    :datetime
#  details       :text
#  id            :integer          not null, primary key
#  maintainer_id :integer
#  maintcost     :decimal(, )
#  updated_at    :datetime
#  workorderno   :string(255)
#
