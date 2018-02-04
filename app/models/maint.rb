class Maint < ActiveRecord::Base
   belongs_to :college
   belongs_to :asset
   belongs_to :maintainer, :class_name => 'AddressBook'
   
   def render_maintenance_type
     ((DropDown::SCHEDULE_MAINT+DropDown::UNSCHEDULE_MAINT).find_all{|disp, value| value == maint_type}).map {|disp, value| disp} [0]
   end
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
