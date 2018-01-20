class Location < ActiveRecord::Base  
  has_ancestry :cache_depth => true, orphan_strategy: :restrict
  before_validation   :set_combo_code
  before_save           :set_combo_code, :set_status
  before_destroy      :valid_for_removal
  after_touch           :update_status

  validates_presence_of  :code, :name, :combo_code
  validates :combo_code, uniqueness: true
  
  belongs_to :college
  belongs_to  :administrator, :class_name => 'Staff', :foreign_key => 'staffadmin_id'
  has_many  :tenants, :dependent => :destroy
  has_many  :damages, :class_name => 'LocationDamage', :foreign_key => 'location_id', :dependent => :destroy
  accepts_nested_attributes_for :damages, :allow_destroy => true#, reject_if: proc { |damages| damages[:description].blank?}
  validates_associated :damages
  
  has_many :fixed_assets, :class_name => 'Asset' #Harta Modal
  has_many :asset_placements #Inventori
  has_many :assets, :through => :asset_placements
  #has_many :asset, :foreign_key => "location_id" --> not required - refer line 15 & 16
  has_many :asset_loss
  
  has_many :reservations, class_name: 'Bookingfacility'
  
  attr_accessor :repairdate
  
  def staff_name
    administrator.try(:name)
  end
  
  def staff_name=(name)
    self.administrator = Staff.find_by_name(name) if name.present?
  end
  
  def parent_code
    parent.try(:combo_code)
  end
  
  def parent_code=(combo_code)
    self.parent = Location.find_by_combo_code(combo_code) if combo_code.present?
  end
  
  
  def translated_location_category
    I18n.t(location_category, :scope => :location_categories)
  end
  
  def set_combo_code
    if ancestry_depth == 0
      self.combo_code = code
    else
      self.combo_code = parent.combo_code + "-" + code
    end
  end

  def set_status
    if typename == 2
      bed_type = "student_bed_female"
    elsif typename == 8
      bed_type = "student_bed_male"
    elsif typename == 1
      bed_type = "staff_house"
    end
    @occupied_location_ids = Tenant.where("keyreturned IS ? AND force_vacate != ?", nil, true).pluck(:location_id)
    #if occupied == true || (parent.occupied == true && parent.status== "_empty") - this line will failed if location is a building
    if occupied == true || (parent.nil? == false && parent.occupied == true && parent.status== "_empty") # if building, lclass will be updated as 1? - suppose 4
      status_type = "damage"
      if typename == 2|| typename == 8
        bed_type = "bed"
      elsif typename == 1
        bed_type = "staff_house"
      end
      
      self.children.each do |c|
        c.occupied = 1
        c.status=self.parent.status
        c.save!
      end
    #required when damaged room is repaired
    elsif (occupied == false && status.include?("_damage"))    #'occupied' in location --> room is damanged (occupied false --> damage is repaired)
      
      #19Jan2018 - start - temp - when damangedroom (declared as rosak while tenant still exist) is REPAIRED (once repaired, must set as occupied) - will ensure location & tenant record are matching
      #status_type = "empty"
      if @occupied_location_ids.include? id
        status_type = "occupied"
      else
        status_type = "empty"
      end
      #19Jan2018 - end temp
      
      if typename == 2
        bed_type = "student_bed_female"
      elsif typename == 8
        bed_type = "student_bed_male"
      elsif typename == 1
        bed_type = "staff_house"
      end
      self.children.each do |c|
        c.occupied = 0               #dah dibaiki
        c.save!
      end
      damages.each do |d|
        if d.repaired_on.nil?
          d.repaired_on = repairdate #Date.today
          d.save!
        end
      end
    elsif @occupied_location_ids.include? id
      status_type = "occupied"
    else
      status_type = "empty"
    end
    "#{bed_type}_#{status_type}"
    self.status = "#{bed_type}_#{status_type}"
  end
  
  def update_status
    update_attribute(:status, set_status)
  end
  
  #named shortcuts
  def location_list
     "#{combo_code}  #{name}"
  end
  
  #Export excel - statistic by level - tenants/reports.html.haml 
  def self.to_csv(options = {})
    #@current_tenants=Tenant.where("keyreturned IS ? AND force_vacate != ?", nil, true)
    student_bed_ids = Location.where(typename: [2,8]).pluck(:id)
    @current_tenants = Tenant.isstudents.where("keyreturned IS ? AND force_vacate != ? and location_id IN(?)", nil, true, student_bed_ids)
    occupied_beds = @current_tenants.pluck(:location_id)
    building_name = all[0].root.name
    CSV.generate(options) do |csv|
        csv << [I18n.t('student.tenant.report_main')] #title added
        csv << [] #blank row added
        csv << [building_name]
        csv << [I18n.t('student.tenant.level'), I18n.t('student.tenant.occupied'), I18n.t('student.tenant.empty'), I18n.t('student.tenant.damaged'), I18n.t('student.tenant.notes')]   
        
        ##############
        lev=[]
        occ_level=[]
        occupiedroomss=[]
        ocbb=[]
        all.each do |bed|      
            ocbb << bed if occupied_beds.include?(bed.id)
        end
        #occupiedroom = ocbb.group_by{|x|x.combo_code[0,6]}.count   #3 aras je yg ade data
        occupiedlevel = ocbb.group_by{|x|x.combo_code[0,6]}
        occupiedlevel.each do |level, beds| #beds
          occ_level << level  #HB-02-
          occupiedbeds_level = beds.group_by{|y|y.combo_code[0,9]}
          occupiedbeds_level.each do |leve, bedss|
            lev << leve[0,6]
          end
          occupiedroomss << occupiedbeds_level.count
        end
        ##################

        num=0
        all.group_by{|x|x.combo_code[0,6]}.sort.reverse.each do |floor, beds|     #by floor
           damangedbed=[]
          #per each level----start
           beds.each do|bed|
              if bed.occupied == true
                damangedbed << bed
             end
           end
           damangedroom = damangedbed.group_by{|x|x.combo_code[0,6]}.count
           hash_occlevel = Hash[occ_level.zip(occupiedroomss)]
           hash_occlevel.default = 0 
           occupiedroom = hash_occlevel[floor]
           allroom = beds.map(&:combo_code).group_by{|x|x[0, x.size-2]}.count# beds.group_by{|x|x.combo_code[0,9]}.count
           if floor[5,1]=="-"
             rev_floor = floor[0,5]   #HB-02-
           elsif floor[5,1]!="-"
             rev_floor = floor          #HB-00B
           end
           csv << [rev_floor, occupiedroom, allroom-occupiedroom-damangedroom, damangedroom]
           num+=1
          #per each level----end
        end

      end
  end
  
  #Export Excel - Census by level - tenants/..../census_level.html.haml (location_id/level)
  def self.to_csv2(options = {})
    
    #For TOTAL no of rooms, damaged rooms, occupied rooms, empty rooms
    #@current_tenants=Tenant.where("keyreturned IS ? AND force_vacate != ?", nil, true)
    student_bed_ids = Location.where(typename: [2,8]).pluck(:id)
    
    #@current_tenants = Tenant.where("keyreturned IS ? AND force_vacate != ? and location_id IN(?)", nil, true, student_bed_ids)
    #default 2 valid students - enable above & disable below 4 checking
    @current_tenants = Tenant.isstudents.where("keyreturned IS ? AND force_vacate != ? and location_id IN(?)", nil, true, student_bed_ids)
    
    @tenantbed_per_level=all.joins(:tenants).where("tenants.id" => @current_tenants)
    tenant_beds_ids = @tenantbed_per_level.pluck(:location_id)
    occupied_rooms = all.where('id IN(?)', tenant_beds_ids).group_by{|x|x.combo_code[0,9]}.count
    all_rooms = all.map(&:combo_code).group_by{|x|x[0, x.size-2]}.count #fixed-3rdOct2017 - all.group_by{|x|x.combo_code[0,9]}.count
    damaged_rooms = all.where(occupied: true).group_by{|x|x.combo_code[0,9]}.count
    
    if all.first.college.code=='amsas'
      floor_label=all[0].parent.parent.name
    else 
      if all[0].combo_code[5,1]=="-"
        floor_label = all[0].combo_code[0,5]
      else
        floor_label = all[0].combo_code[0,6]
      end
    end
    
    
    #For tenants COUNT group by programme
    @all_tenants_wstudent = @current_tenants.joins(:location).where('location_id IN(?) and student_id IN(?)', tenant_beds_ids, Student.all.pluck(:id))
    @students_prog = Student.where('id IN (?)', @all_tenants_wstudent.pluck(:student_id)).group_by{|j|j.course_id}
    @all_tenants_wostudent = @current_tenants.joins(:location).where('location_id IN(?) and (student_id is null OR student_id NOT IN(?))', tenant_beds_ids, Student.all.pluck(:id))
   
    CSV.generate(options) do |csv|
        csv << [I18n.t('student.tenant.census')] #title added
        csv << [] #blank row added
        csv << [floor_label]
        csv << [I18n.t('location.code'), I18n.t('location.name'), I18n.t('student.name'), I18n.t('student.icno'), I18n.t('student.students.matrixno'), I18n.t('course.name'), all.first.college.code=='amsas' ? "Siri" : I18n.t('training.intake.description'), I18n.t('student.students.stelno') , I18n.t('student.tenant.notes')]  

        all.sort_by{|t|t.combo_code}.each do |bed|
          if bed.occupied==true
             csv << [bed.combo_code, bed.name, "#{bed.parent.damages.where(document_id: 1).last.description rescue (I18n.t 'student.tenant.damage')}"]
          else
            if bed.tenants.count > 0 && bed.tenants.last.keyreturned==nil && bed.tenants.last.force_vacate !=true
               if bed.tenants.last.student.nil?
                  csv << [bed.combo_code, bed.name, I18n.t('student.tenant.tenancy_details_nil')]
               else
                  validstu=Student.valid_students.pluck(:id)
                  a=true if validstu.include?(bed.tenants.last.student.id)
                  if all.first.college.code=='amsas'
                    intake_detailing=bed.tenants.last.student.intakestudent.name
                  else
                    intake_detailing=bed.tenants.last.student.intake_num
                  end
                  csv << [bed.combo_code, bed.name, "\'#{bed.tenants.last.try(:student).try(:name) if a}\'", "\'#{bed.tenants.last.try(:student).try(:icno) if a}\'", "\'#{bed.tenants.last.try(:student).try(:matrixno) if a}\'", "\'#{bed.tenants.last.try(:student).try(:course).try(:programme_list) if a}\'", "\'#{intake_detailing if a}\'", "\'#{bed.tenants.last.try(:student).try(:stelno) if a}\'"]  #"=\"" + myVariable + "\""
               end
             else
               csv << [bed.combo_code, bed.name] #leaves empty, coz has no values
             end     
          end
        end

        if all.first.college.code=='amsas'
	  course_heading="\'Siri | #{(I18n.t 'course.name')}\'"
	else
	  course_heading="\'#{(I18n.t 'course.name')} - #{(I18n.t 'training.intake.description')}\'"
	end
        
        csv << [] #blank row added
        csv << [] #blank row added
        csv << [ I18n.t('student.tenant.total_empty'), all_rooms-damaged_rooms-occupied_rooms]
        csv << [I18n.t('student.tenant.total_damaged'), damaged_rooms]
        csv << [I18n.t('student.tenant.total_occupied'), occupied_rooms]
        csv << [ I18n.t('student.tenant.total_all'), all_rooms]

        csv << [] #blank row added
        csv << [] #blank row added
        csv << [course_heading, I18n.t('student.tenant.total')]
	if all.first.college.code=='amsas'
           Student.where('id IN (?)', @all_tenants_wstudent.pluck(:student_id)).group_by(&:intakestudent).each do |intakestu, students2|
	     csv << [intakestu.siri_programmelist, students2.count]
	   end
	else
           @students_prog.each do |course_id, students|
              students.group_by{|k|k.intake}.each do |intake, students2|
                csv << [students.first.course.name+" - "+students2.first.intake_num, students2.count]
              end
           end
	end
        if @all_tenants_wostudent.count > 0
           csv << [(I18n.t 'student.tenant.tenancy_details_nil'), @all_tenants_wostudent.count]
        end
        csv << [(I18n.t 'student.tenant.total_tenants'),@tenantbed_per_level.count]
     end
  end
  
  #Export Excel - statistic by block(total room status & tenant's programme) - tenant/statistics.html.haml
  def self.to_csv3(options = {})
    
    #For statistic by block (room status breakdown)
    #@current_tenants=Tenant.where("keyreturned IS ? AND force_vacate != ?", nil, true)
    student_bed_ids = Location.where(typename: [2,8]).pluck(:id)
    @current_tenants = Tenant.isstudents.where("keyreturned IS ? AND force_vacate != ? and location_id IN(?)", nil, true, student_bed_ids)
    all_beds = all
    all_rooms = all_beds.group_by{|x|x.combo_code[0,x.combo_code.size-2]}
    damaged_rooms = all_beds.where(occupied: true).group_by{|x|x.combo_code[0,x.combo_code.size-2]}
    occupied_rooms = all_beds.where('id IN(?)', @current_tenants.pluck(:location_id)).group_by{|x|x.combo_code[0,x.combo_code.size-2]}
    
    #For statistic by block (tenant's programme)
    @tenantbed_per_block = all.joins(:tenants).where("tenants.id" => @current_tenants)
    @all_tenants_wstudent = @current_tenants.joins(:location).where('location_id IN(?) and student_id IN(?)', @tenantbed_per_block.pluck(:id), Student.all.pluck(:id))
    @students_prog = Student.where('id IN (?)', @all_tenants_wstudent.pluck(:student_id)).group_by{|j|j.course_id}
    @all_tenants_wostudent = @current_tenants.joins(:location).where('location_id IN(?) and (student_id is null OR student_id NOT IN(?))', @tenantbed_per_block.pluck(:id), Student.all.pluck(:id))
    
     if all.first.college.code=='amsas'
       course_heading="\'Siri | #{(I18n.t 'course.name')}\'"
     else
       course_heading="\'#{(I18n.t 'course.name')} - #{(I18n.t 'training.intake.description')}\'"
     end

    CSV.generate(options) do |csv|
        csv << [all_beds[0].parent.parent.parent.name]
        csv << [] #blank row added
        csv << [I18n.t('student.tenant.room_status_title')] #title added
        csv << [] #blank row added
        csv << [I18n.t('student.tenant.room'), I18n.t('student.tenant.total')]
        csv << [I18n.t('student.tenant.total_empty'), all_rooms.count-damaged_rooms.count-occupied_rooms.count]
        csv << [I18n.t('student.tenant.total_occupied'), occupied_rooms.count]
        csv << [I18n.t('student.tenant.total_damaged'), damaged_rooms.count]
        csv << [I18n.t('student.tenant.total_rooms'), all_rooms.count]
        csv << [] #blank row added
        csv << [] #blank row added
        csv << [I18n.t('student.tenant.tenant_programme_title')] #title added
        csv << [] #blank row added
        csv << [course_heading, (I18n.t 'student.tenant.total')]
        if all.first.college.code=='amsas'
           Student.where('id IN (?)', @all_tenants_wstudent.pluck(:student_id)).group_by(&:intakestudent).each do |intakestu, students2|
             csv << [intakestu.siri_programmelist, students2.count]
           end
        else
          @students_prog.each do |course_id, students|  
             students.group_by{|k|k.intake}.each do |intake, students2|
                csv << [students.first.course.name+" - "+students2.first.intake_num, students2.count]
             end
          end
	end
        if @all_tenants_wostudent.count > 0
           csv << [(I18n.t 'student.tenant.tenancy_details_nil'), @all_tenants_wostudent.count]
        end
        csv << [(I18n.t 'student.tenant.total_tenants'), @tenantbed_per_block.count.to_s]
    end
    
  end
  
  def valid_for_removal
    if tenants.count > 0
      errors.add(:base, "#{I18n.t('student.tenant.person').titleize} : #{tenants.count} #{I18n.t('actions.records')}")
      return false
    else
      return true
    end
  end
  
  
  
  #####icms_acct purposes - start - 3-4thOct2017
  #Export Excel - Census by level - tenants/..../census_level.html.haml (location_id/level)
  def self.to_csv2_all(options = {})
    
    #For TOTAL no of rooms, damaged rooms, occupied rooms, empty rooms
    #@current_tenants=Tenant.where("keyreturned IS ? AND force_vacate != ?", nil, true)
    student_bed_ids = Location.where(typename: [2,8]).pluck(:id)
    @current_tenants = Tenant.where("keyreturned IS ? AND force_vacate != ? and location_id IN(?)", nil, true, student_bed_ids)
    @tenantbed_per_level=all.joins(:tenants).where("tenants.id" => @current_tenants)
    tenant_beds_ids = @tenantbed_per_level.pluck(:location_id)
    occupied_rooms = all.where('id IN(?)', tenant_beds_ids).group_by{|x|x.combo_code[0,9]}.count
    all_rooms = all.map(&:combo_code).group_by{|x|x[0, x.size-2]}.count #fixed-3rdOct2017 - all.group_by{|x|x.combo_code[0,9]}.count
    damaged_rooms = all.where(occupied: true).group_by{|x|x.combo_code[0,9]}.count
    
    if all.first.college.code=='amsas'
      floor_label=all[0].parent.parent.name
    else 
      if all[0].combo_code[5,1]=="-"
        floor_label = all[0].combo_code[0,5]
      else
        floor_label = all[0].combo_code[0,6]
      end
    end
    
    
    #For tenants COUNT group by programme
    @all_tenants_wstudent = @current_tenants.joins(:location).where('location_id IN(?) and student_id IN(?)', tenant_beds_ids, Student.all.pluck(:id))
    @students_prog = Student.where('id IN (?)', @all_tenants_wstudent.pluck(:student_id)).group_by{|j|j.course_id}
    @all_tenants_wostudent = @current_tenants.joins(:location).where('location_id IN(?) and (student_id is null OR student_id NOT IN(?))', tenant_beds_ids, Student.all.pluck(:id))
   
    CSV.generate(options) do |csv|
        csv << [I18n.t('student.tenant.census')] #title added
        csv << [] #blank row added
        csv << [floor_label]
        csv << [I18n.t('location.code'), I18n.t('location.name'), I18n.t('student.name'), I18n.t('student.icno'), I18n.t('student.students.matrixno'), I18n.t('course.name'), all.first.college.code=='amsas' ? "Siri" : I18n.t('training.intake.description'), I18n.t('student.students.stelno') , I18n.t('student.tenant.notes')]  

        all.sort_by{|t|t.combo_code}.each do |bed|
          if bed.occupied==true
             csv << [bed.combo_code, bed.name, "#{bed.parent.damages.where(document_id: 1).last.description rescue (I18n.t 'student.tenant.damage')}"]
          else
            if bed.tenants.count > 0 && bed.tenants.last.keyreturned==nil && bed.tenants.last.force_vacate !=true
               if bed.tenants.last.student.nil?
                  csv << [bed.combo_code, bed.name, I18n.t('student.tenant.tenancy_details_nil')]
               else
                  if all.first.college.code=='amsas'
                    intake_detailing=bed.tenants.last.student.intakestudent.name
                  else
                    intake_detailing=bed.tenants.last.student.intake_num
                  end
                  csv << [bed.combo_code, bed.name, "\'#{bed.tenants.last.try(:student).try(:name) }\'", "\'#{bed.tenants.last.try(:student).try(:icno)}\'", "\'#{bed.tenants.last.try(:student).try(:matrixno)}\'", "\'#{bed.tenants.last.try(:student).try(:course).try(:programme_list) }\'", intake_detailing, "\'#{bed.tenants.last.try(:student).try(:stelno) }\'"]  #"=\"" + myVariable + "\""
               end
             else
               csv << [bed.combo_code, bed.name] #leaves empty, coz has no values
             end     
          end
        end

        if all.first.college.code=='amsas'
	  course_heading="\'Siri | #{(I18n.t 'course.name')}\'"
	else
	  course_heading="\'#{(I18n.t 'course.name')} - #{(I18n.t 'training.intake.description')}\'"
	end
        
        csv << [] #blank row added
        csv << [] #blank row added
        csv << [ I18n.t('student.tenant.total_empty'), all_rooms-damaged_rooms-occupied_rooms]
        csv << [I18n.t('student.tenant.total_damaged'), damaged_rooms]
        csv << [I18n.t('student.tenant.total_occupied'), occupied_rooms]
        csv << [ I18n.t('student.tenant.total_all'), all_rooms]

        csv << [] #blank row added
        csv << [] #blank row added
        csv << [course_heading, I18n.t('student.tenant.total')]
	if all.first.college.code=='amsas'
           Student.where('id IN (?)', @all_tenants_wstudent.pluck(:student_id)).group_by(&:intakestudent).each do |intakestu, students2|
	     csv << [intakestu.siri_programmelist, students2.count]
	   end
	else
           @students_prog.each do |course_id, students|
              students.group_by{|k|k.intake}.each do |intake, students2|
                csv << [students.first.course.name+" - "+students2.first.intake_num, students2.count]
              end
           end
	end
        if @all_tenants_wostudent.count > 0
           csv << [(I18n.t 'student.tenant.tenancy_details_nil'), @all_tenants_wostudent.count]
        end
        csv << [(I18n.t 'student.tenant.total_tenants'),@tenantbed_per_level.count]
     end
  end
  
  #Export excel - statistic by level - tenants/reports.html.haml 
  def self.to_csv_all(options = {})
    #@current_tenants=Tenant.where("keyreturned IS ? AND force_vacate != ?", nil, true)
    student_bed_ids = Location.where(typename: [2,8]).pluck(:id)
    @current_tenants = Tenant.where("keyreturned IS ? AND force_vacate != ? and location_id IN(?)", nil, true, student_bed_ids)
    occupied_beds = @current_tenants.pluck(:location_id)
    building_name = all[0].root.name
    CSV.generate(options) do |csv|
        csv << [I18n.t('student.tenant.report_main')] #title added
        csv << [] #blank row added
        csv << [building_name]
        csv << [I18n.t('student.tenant.level'), I18n.t('student.tenant.occupied'), I18n.t('student.tenant.empty'), I18n.t('student.tenant.damaged'), I18n.t('student.tenant.notes')]   
        
        ##############
        lev=[]
        occ_level=[]
        occupiedroomss=[]
        ocbb=[]
        all.each do |bed|      
            ocbb << bed if occupied_beds.include?(bed.id)
        end
        #occupiedroom = ocbb.group_by{|x|x.combo_code[0,6]}.count   #3 aras je yg ade data
        occupiedlevel = ocbb.group_by{|x|x.combo_code[0,6]}
        occupiedlevel.each do |level, beds| #beds
          occ_level << level  #HB-02-
          occupiedbeds_level = beds.group_by{|y|y.combo_code[0,9]}
          occupiedbeds_level.each do |leve, bedss|
            lev << leve[0,6]
          end
          occupiedroomss << occupiedbeds_level.count
        end
        ##################

        num=0
        all.group_by{|x|x.combo_code[0,6]}.sort.reverse.each do |floor, beds|     #by floor
           damangedbed=[]
          #per each level----start
           beds.each do|bed|
              if bed.occupied == true
                damangedbed << bed
             end
           end
           damangedroom = damangedbed.group_by{|x|x.combo_code[0,6]}.count
           hash_occlevel = Hash[occ_level.zip(occupiedroomss)]
           hash_occlevel.default = 0 
           occupiedroom = hash_occlevel[floor]
           allroom = beds.map(&:combo_code).group_by{|x|x[0, x.size-2]}.count #beds.group_by{|x|x.combo_code[0,9]}.count
           if floor[5,1]=="-"
             rev_floor = floor[0,5]   #HB-02-
           elsif floor[5,1]!="-"
             rev_floor = floor          #HB-00B
           end
           csv << [rev_floor, occupiedroom, allroom-occupiedroom-damangedroom, damangedroom]
           num+=1
          #per each level----end
        end

      end
  end
  
  #Export Excel - statistic by block(total room status & tenant's programme) - tenant/statistics.html.haml
  def self.to_csv3_all(options = {})
    
    #For statistic by block (room status breakdown)
    #@current_tenants=Tenant.where("keyreturned IS ? AND force_vacate != ?", nil, true)
    student_bed_ids = Location.where(typename: [2,8]).pluck(:id)
    @current_tenants = Tenant.where("keyreturned IS ? AND force_vacate != ? and location_id IN(?)", nil, true, student_bed_ids)
    all_beds = all
    all_rooms = all_beds.group_by{|x|x.combo_code[0,x.combo_code.size-2]}
    damaged_rooms = all_beds.where(occupied: true).group_by{|x|x.combo_code[0,x.combo_code.size-2]}
    occupied_rooms = all_beds.where('id IN(?)', @current_tenants.pluck(:location_id)).group_by{|x|x.combo_code[0,x.combo_code.size-2]}
    
    #For statistic by block (tenant's programme)
    @tenantbed_per_block = all.joins(:tenants).where("tenants.id" => @current_tenants)
    @all_tenants_wstudent = @current_tenants.joins(:location).where('location_id IN(?) and student_id IN(?)', @tenantbed_per_block.pluck(:id), Student.all.pluck(:id))
    @students_prog = Student.where('id IN (?)', @all_tenants_wstudent.pluck(:student_id)).group_by{|j|j.course_id}
    @all_tenants_wostudent = @current_tenants.joins(:location).where('location_id IN(?) and (student_id is null OR student_id NOT IN(?))', @tenantbed_per_block.pluck(:id), Student.all.pluck(:id))
    
     if all.first.college.code=='amsas'
       course_heading="\'Siri | #{(I18n.t 'course.name')}\'"
     else
       course_heading="\'#{(I18n.t 'course.name')} - #{(I18n.t 'training.intake.description')}\'"
     end

    CSV.generate(options) do |csv|
        csv << [all_beds[0].parent.parent.parent.name]
        csv << [] #blank row added
        csv << [I18n.t('student.tenant.room_status_title')] #title added
        csv << [] #blank row added
        csv << [I18n.t('student.tenant.room'), I18n.t('student.tenant.total')]
        csv << [I18n.t('student.tenant.total_empty'), all_rooms.count-damaged_rooms.count-occupied_rooms.count]
        csv << [I18n.t('student.tenant.total_occupied'), occupied_rooms.count]
        csv << [I18n.t('student.tenant.total_damaged'), damaged_rooms.count]
        csv << [I18n.t('student.tenant.total_rooms'), all_rooms.count]
        csv << [] #blank row added
        csv << [] #blank row added
        csv << [I18n.t('student.tenant.tenant_programme_title')] #title added
        csv << [] #blank row added
        csv << [course_heading, (I18n.t 'student.tenant.total')]
        if all.first.college.code=='amsas'
           Student.where('id IN (?)', @all_tenants_wstudent.pluck(:student_id)).group_by(&:intakestudent).each do |intakestu, students2|
	     csv << [intakestu.siri_programmelist, students2.count]
	   end
	else
          @students_prog.each do |course_id, students|  
             students.group_by{|k|k.intake}.each do |intake, students2|
                csv << [students.first.course.name+" - "+students2.first.intake_num, students2.count]
             end
          end
	end
        if @all_tenants_wostudent.count > 0
           csv << [(I18n.t 'student.tenant.tenancy_details_nil'), @all_tenants_wostudent.count]
        end
        csv << [(I18n.t 'student.tenant.total_tenants'), @tenantbed_per_block.count.to_s]
    end
    
  end
  #####icms_acct purposes - end - 3-4thOct2017
  
  
end

# == Schema Information
#
# Table name: locations
#
#  allocatable    :boolean
#  ancestry       :string(255)
#  ancestry_depth :integer          default(0)
#  code           :string(255)
#  combo_code     :string(255)
#  created_at     :datetime
#  id             :integer          not null, primary key
#  lclass         :integer
#  name           :string(255)
#  occupied       :boolean
#  staffadmin_id  :integer
#  status         :string(255)
#  typename       :integer
#  updated_at     :datetime
#
