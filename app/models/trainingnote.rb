class Trainingnote < ActiveRecord::Base
  serialize :data, Hash
  
  # befores, relationships, validations, before logic, validation logic, 
   #controller searches, variables, lists, relationship checking
   
  #before_save :get_topic_id_from_topicdetail#:get_topic_id_from_timetable
  before_destroy :restrict_when_use_in_lesson_plan
  #belongs_to :topic
  #belongs_to :timetable
  belongs_to :note_creator, :class_name => 'Staff', :foreign_key => :staff_id
  belongs_to :topicdetail, :foreign_key=> 'topicdetail_id'
  
  #refer LessonPlan -> copy_attached_doc_trainingnotes
  belongs_to :schedule, :class_name => 'WeeklytimetableDetail', :foreign_key => 'timetable_id'
  belongs_to :college

  #trial section
  has_many :lesson_plan_trainingnotes# , :dependent => :nullify #:destroy # --> once trainingnote in topic details removed, lesson_plan_trainingnote's record will be REMOVED
  has_many :lesson_plans, :through => :lesson_plan_trainingnotes
  #trial section
  
  has_attached_file :document,
                    :url => "/assets/notes/:id/:style/:basename.:extension",
                    :path => ":rails_root/public/assets/notes/:id/:style/:basename.:extension"
  validates_attachment_size :document, :less_than => 50.megabytes  
  validates_attachment_content_type :document, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif","text/plain","application/pdf", "application/mspowerpoint","application/msword", "application/vnd.openxmlformats-officedocument.wordprocessingml.document", "application/vnd.openxmlformats-officedocument.presentationml.presentation","application/vnd.oasis.opendocument.text","application/vnd.oasis.opendocument.presentation", "video/mp4","video/webm", "application/binary"]
  
  #validates :document_file_name, uniqueness: true
  validates :staff_id, presence: true
  #attr_accessor :topic_id
  
  
  def youtube_link=(value)
    data[:youtube_link] = value
  end
  def youtube_link
    data[:youtube_link]
  end
  

  #to retrieve topic id if notes uploaded from topic detail
  def get_topic_id_from_topicdetail
    #if topicdetail_id #!= nil
      timetable_id = 1 #topicdetail_id#Topicdetail.find(topicdetail_id).topic_code
    #end
  end
  
  def subject_topic2 #subject_topic -> refer relationship line above
    if topicdetail_id!= nil       #view subject code, topic & title of notes
      topic_id = Topicdetail.find(topicdetail_id).topic_code
      if topic_id!=nil   
        ##topic_list = Programme.at_depth(3).map(&:id)
        ##subject_list = Programme.at_depth(2).map(&:id)
        ##subject_id = Programme.find(topic_id).parent.id
        #topic_list=Programme.where(course_type: 'Topic').pluck(:id)
        #subject_list=Programme.where(course_type: 'Subject').pluck(:id)
        #subject_id=Programme.find(topic_id).ancestors.where(course_type: 'Subject').first.id

        topic_rec=Programme.find(topic_id)
        subject_code=topic_rec.ancestors.where(course_type: 'Subject').first.code
        topic_name=topic_rec.name

        ##if topic_list.include?(topic_id)==true && subject_list.include?(subject_id)==true
          #"#{Programme.find(Topicdetail.find(topicdetail_id).topic_code).parent.code}| #{Programme.find(Topicdetail.find(topicdetail_id).topic_code).name} - #{title}"
          "#{subject_code} | #{topic_name} - #{title}"
        ##end
      else
        "#{title}"
      end      
    else
      "#{title}"
    end
  end
  
  #define scope
  def self.subject_search(query)
    if query
      sel_subject = Programme.where('(code ILIKE(?) OR name ILIKE(?)) AND course_type=?',"%#{query}%", "%#{query}%", "Subject")
      if sel_subject!=nil
        acc_topic_ids=[]
        sel_subject.each{|x|acc_topic_ids+=x.descendants.pluck(:id)}
        topicdetails_ids = Topicdetail.where('topic_code IN(?)', acc_topic_ids).pluck(:id)
      else
        topicdetails_ids = []
      end
      where('topicdetail_id IN(?)', topicdetails_ids)
    end
  end
    
  def self.programme_search(query)
    if query
      sel_programme=Programme.roots.where('name ILIKE(?) OR course_type ILIKE(?) OR level ILIKE(?) OR code ILIKE(?) ',"%#{query}%", "%#{query}%", "%#{query}%", "%#{query}%")
      if sel_programme!=nil 
        acc_desc_ids=[]
        sel_programme.each{|x|acc_desc_ids+=x.descendants.where(course_type: ['Topic', 'Subtopic']).pluck(:id)}
        topicdetail_ids=Topicdetail.where(topic_code: acc_desc_ids).pluck(:id)
      else
        topicdetail_ids=[]
      end
      where('topicdetail_id IN(?)', topicdetail_ids)
    end
  end
  
  # whitelist the scope
  def self.ransackable_scopes(auth_object = nil)
    [:subject_search, :programme_search]
  end
  
  def self.search2(search)
    common_subject = Programme.where('course_type=?','Commonsubject').pluck(:id)
    #timetable_id exist (note created via lesson plan -->select timetable which consist topic)
    #but if selected topic has no TOPIC DETAIL yet...
    notopicdetail_timetable_exist = Trainingnote.where('topicdetail_id is null AND timetable_id is not null').pluck(:timetable_id)
    topic_timetable_exist_raw = WeeklytimetableDetail.where('id iN(?)', notopicdetail_timetable_exist).pluck(:topic)
    if search 
      if search == '0'
        training_notes = Trainingnote.all
      else
        if search == '1'
          topicids = Programme.where('id IN(?)', common_subject).first.descendants.at_depth(3).pluck(:id)
          subtopicids = Programme.where('id IN(?)', common_subject).first.descendants.at_depth(4).pluck(:id)
        else
          topicids = Programme.where(id: search).first.descendants.at_depth(3).pluck(:id)
          subtopicids = Programme.where(id: search).first.descendants.at_depth(4).pluck(:id)
        end
        topic_timetable_exist = Programme.where('id IN(?) AND (id IN(?) OR id IN(?))', topic_timetable_exist_raw, topicids, subtopicids).pluck(:id)
        timetableids = WeeklytimetableDetail.where('topic IN(?)', topic_timetable_exist).pluck(:id)
        topicdetailsids = Topicdetail.where('topic_code IN(?) OR topic_code IN(?)', topicids, subtopicids).pluck(:id)
        nobody_ownids = Trainingnote.where('timetable_id is null AND topicdetail_id is null').pluck(:id)
        training_notes = Trainingnote.where('topicdetail_id IN(?) OR id IN(?) OR timetable_id IN(?)', topicdetailsids, nobody_ownids, timetableids)
      end
    end
    training_notes
  end
  
  def restrict_when_use_in_lesson_plan
    if timetable_id?
      return false
    else
      return true
    end
  end
  
end