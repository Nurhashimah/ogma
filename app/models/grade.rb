class Grade < ActiveRecord::Base
  
  validates_presence_of :student_id, :subject_id, :examweight#, :exam1marks #added examweight for multiple edit - same subject - this item must exist
  validates_uniqueness_of :subject_id, :scope => :student_id, :message => " - This student has already taken this subject"
  validates :exam1marks, :finalscore, numericality: {greater_than_or_equal_to: 0, less_than_or_equal_to: 100}
 # validates_presence_of :sent_date, :if => :sent_to_BPL?
  
  belongs_to :studentgrade, :class_name => 'Student', :foreign_key => 'student_id'  #Link to Model student
  belongs_to :subjectgrade, :class_name => 'Programme', :foreign_key => 'subject_id'  #Link to Model subject

  has_many :scores, :dependent => :destroy
  accepts_nested_attributes_for :scores,:allow_destroy => true, :reject_if => lambda { |a| a[:description].blank? } #allow for destroy - 17June2013
  
  before_save :check_formative_valid
  
  attr_accessor :intake_id, :marks_70, :formative_weight_sum, :formative_marks_sum

  # define scope
  def self.student_search(query)
    student_ids = Student.where('name ILIKE(?) or matrixno ILIKE(?)', "%#{query}%", "%#{query}%").pluck(:id)
    where('student_id IN(?)', student_ids)
  end
  
  def self.subject_search(query)
    subject_ids = Programme.where('(name ILIKE(?) or code ILIKE(?)) and course_type=?', "%#{query}%", "%#{query}%", "Subject").pluck(:id).uniq
    where('subject_id IN(?)', subject_ids)
  end
  
  def self.grading_search(query)
    all_grades = Grade.all
    resu = []
    for grd in all_grades
      resu << grd.id if grd.set_gred==query
    end
    where('id IN(?)', resu)
  end

  # whitelist the scope
  def self.ransackable_scopes(auth_object = nil)
    [:student_search, :subject_search, :grading_search]
  end
  
  def total_summative
    if exam1marks == 0 || exam1marks == nil
      0
    else
      (exam1marks * examweight)/100
    end
  end
  
  def total_per
    Score.where(grade_id: id).sum(:weightage)
  end
    
  def total_formative
    Score.where(grade_id: id).sum(:marks)
  end
  
  def finale
    total_formative+total_summative #8Nov2015
    #score.to_f + total_summative    #23August2013
    #((exam1marks * examweight)/100) + ((total_formative * (100 - examweight)/100))
  end
  
  def set_gred
    if finale <= 35 
      "E"
    elsif finale <= 40
      "D"
    elsif finale <= 45
      "D+"
    elsif finale <= 50
      "C-"
    elsif finale <= 55
      "C"
    elsif finale <= 60
      "C+"
    elsif finale <= 65
      "B-"
    elsif finale <= 70
      "B"
    elsif finale <= 75
      "B+"
    elsif finale <= 80
      "A-"
    else
      "A"
    end
  end
  
  def set_NG
    if finale < 35  #<= 35 
      0.00
    elsif finale < 40 #<= 40
      1.00
    elsif finale < 45 #<= 45
      1.33
    elsif finale < 50 #<= 50
      1.67
    elsif finale < 55 #<= 55
      2.00
    elsif finale < 60 #<= 60
      2.33
    elsif finale < 65 #<= 65
      2.67
    elsif finale < 70 #<= 70
      3.00
    elsif finale < 75 #<= 75
      3.33
    elsif finale < 80 #<= 80
      3.67
    else
      4.00
    end
  end 
  
  def self.search2(search)
    common_subject = Programme.where('course_type=?','Commonsubject').pluck(:id)
    posbasics=Programme.where(course_type: ['Pos Basik', 'Diploma Lanjutan', 'Pengkhususan'])
    posbasics_subjects=[]
    posbasics.each{|x|posbasics_subjects+= x.descendants.where(course_type: ['Subject', 'Commonsubject']).pluck(:id)}
    if search 
      if search == '0'
        @grades = Grade.all.order(:subject_id)
      elsif search == '1'
        @grades = Grade.where("subject_id IN (?)", common_subject).order(:subject_id)
      elsif search =='2'
        @grades = Grade.where("subject_id IN (?)", posbasics_subjects).order(:subject_id)
      else
        subject_of_programme = Programme.find(search).descendants.at_depth(2).map(&:id)
        @grades = Grade.where("subject_id IN (?)", subject_of_programme)
      end
    else
       @grades = Grade.all.order(:subject_id)
    end
    #ABOVE : order(:subject_id) - added, when group by subject, won't split up - continueos in paging
  end
  
  private 
  
    def check_formative_valid #add error msg in controller
       if Programme.roots.where(course_type: 'Diploma').pluck(:id).include?(subjectgrade.root_id)
         if scores && scores.count > 0
           if scores.map(&:weightage).sum > 30 || scores.map(&:marks).sum > 30
             return false
           else
             return true
           end
         end
       end
    end
  
end