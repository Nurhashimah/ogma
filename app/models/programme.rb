class Programme < ActiveRecord::Base
  has_ancestry :cache_depth => true
  
  def subject_list
      "#{code}" + " " + "#{name}"   
  end
  
  def programme_list
    if is_root?
      "#{course_type}" + " " + "#{name}"   
    else
    end
  end
  
  def semester_subject_topic
    if ancestry_depth == 3
      "Sem #{parent.parent.code}"+"-"+"#{parent.code}"+" | "+"#{name}"
    elsif ancestry_depth == 4
      ">>Sem #{parent.parent.parent.code}"+"-"+"#{parent.parent.code}"+" | "+"#{code} "+"#{name}"
    end
  end
  
end

# == Schema Information
#
# Table name: programmes
#
#  ancestry       :string(255)
#  ancestry_depth :integer
#  code           :string(255)
#  combo_code     :string(255)
#  course_type    :string(255)
#  created_at     :datetime
#  credits        :integer
#  duration       :integer
#  duration_type  :integer
#  id             :integer          not null, primary key
#  name           :string(255)
#  objective      :text
#  status         :integer
#  updated_at     :datetime
#
