class Postinfo < ActiveRecord::Base
  has_many :positions
  belongs_to :employgrade, :foreign_key => "staffgrade_id"
  belongs_to :college
  
  validates :details, :staffgrade_id, presence: true
  
  def details_grade 
    "#{details}"+" - "+"#{employgrade.name_and_group}"
  end
  
  def details_start
    details[0, 5]
  end
  
  def self.position_search(query)
    ids=Position.where(id: query).pluck(:postinfo_id)
    where(id: ids)
  end
  
  # whitelist the scope
  def self.ransackable_scopes(auth_object = nil)
    [:position_search]
  end
end
