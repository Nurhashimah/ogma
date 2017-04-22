class Staffattendancesearch < ActiveRecord::Base
  
  belongs_to :college
  
  def staffattendances
    @staffattendances ||= find_staffattendances
  end
  
  private

  def find_staffattendances
    StaffAttendance.where(conditions).order(orders)   
  end

  def thumb_id_conditions
     ["thumb_id=?", thumb_id] #compulsory 
  end
   
  def logged_at_conditions
      logged_at2=logged_at+8.hours
      monthend = logged_at.end_of_month+8.hours
      ["logged_at>=? and logged_at<=?", logged_at2, monthend] unless logged_at.blank?
  end
  
  def orders
    "logged_at ASC"
  end  

  def conditions
    [conditions_clauses.join(' AND '), *conditions_options] #works like OR?????
  end

  def conditions_clauses
    conditions_parts.map { |condition| condition.first }
  end

  def conditions_options
    conditions_parts.map { |condition| condition[1..-1] }.flatten
  end

  def conditions_parts
    private_methods(false).grep(/_conditions$/).map { |m| send(m) }.compact
  end
  
end
