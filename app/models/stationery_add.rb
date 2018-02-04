class StationeryAdd < ActiveRecord::Base
  belongs_to :college
  belongs_to :stationery
  belongs_to :supplier, :class_name => "AddressBook", :foreign_key => "supplier_id"
  
  validates_presence_of :supplier_id, :unitcost, :received, :quantity #, :lpono
  validates_format_of      :quantity, :with => /[1-9]/, :message => I18n.t('activerecord.errors.messages.invalid')
  validates_format_of      :unitcost, :with => /[1-9]/, :message => I18n.t('activerecord.errors.messages.invalid')
  
  attr_accessor :total
  
  def line_item_value
    quantity * unitcost
  end
  
  def total
    
  end
  
  def boo
    "ba"
  end
  
  def details
    "#{document} | #{lpono}"
  end
end

# == Schema Information
#
# Table name: addsuppliers
#
#  created_at  :datetime
#  document    :string(255)
#  id          :integer          not null, primary key
#  lpono       :string(255)
#  quantity    :decimal(, )
#  received    :date
#  supplier_id :integer
#  unitcost    :decimal(, )
#  updated_at  :datetime
#
