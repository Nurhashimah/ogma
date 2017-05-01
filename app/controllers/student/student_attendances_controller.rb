class Student::StudentAttendancesController < ApplicationController
  filter_access_to :index, :new, :create, :new_multiple, :new_multiple_intake, :create_multiple, :student_attendan_form, :edit_multiple, :update_multiple, :attribute_check => false
  filter_access_to :show, :edit, :update, :destroy, :attribute_check => true
  before_action :set_student_attendance, only: [:show, :edit, :update, :destroy]
  before_action :set_schedule_student_list, only: [:new, :create, :new_multiple_intake]
  
  # GET /student_attendances
  # GET /student_attendances.xml
  def index
    current_roles= current_user.roles.pluck(:authname)
    position_exist = current_user.userable.positions
    programme_list_ids = Programme.roots.pluck(:id)
    current_roles=current_user.roles.pluck(:authname)
    is_admin=true if current_roles.include?('developer') || current_roles.include?('administration') || current_roles.include?('student_attendances_module_admin') 
    if position_exist
      lecturer_programme = current_user.userable.positions[0].unit
      unless lecturer_programme.nil?
        programme = Programme.where('name ILIKE (?) AND ancestry_depth=?',"%#{lecturer_programme}%",0)  if !(lecturer_programme=="Pos Basik" || lecturer_programme=="Diploma Lanjutan")
      end
      unless programme.nil? || programme.count==0
        @programme_id = programme.try(:first).try(:id)
        @intake_list2 = Student.where('course_id=?',@programme_id).select("DISTINCT intake_id, course_id").order(:intake_id) 
        topics_ids_this_prog = Programme.find(@programme_id).descendants.where(course_type: ['Topic', 'Subtopic']).map(&:id)
        @student_ids = Student.where('course_id=?',@programme_id).pluck(:id)
      else
        # NOTE - system
        if is_admin==true
          if current_user.college.code=='amsas'
            topics_ids_this_prog=WeeklytimetableDetail.pluck(:subject)
          else
            topics_ids_this_prog=WeeklytimetableDetail.pluck(:topic)
          end
          programme_list_ids=Programme.where(id: topics_ids_this_prog).map(&:root_programme).uniq
        else
          #Amsas: also use this part - based on logged in lecturer
          #additional-start - to limit programme list therein subject-topic taught by current lecturer/jurulatih 
          if current_user.college.code=='amsas'
            topics_ids_this_prog=WeeklytimetableDetail.where(lecturer_id: current_user.userable_id).pluck(:subject)
          else
            topics_ids_this_prog=WeeklytimetableDetail.where(lecturer_id: current_user.userable_id).pluck(:topic)
          end
          programme_list_ids=Programme.where(id: topics_ids_this_prog).map(&:root_programme).uniq
          #additional-end
        end
        @intake_list2 = Student.where('course_id IS NOT NULL and course_id IN(?)', programme_list_ids).select("DISTINCT intake_id, course_id").order("course_id, intake_id") 
        @student_ids = Student.all.pluck(:id)
        # TODO - kskbjb: common subjects - refer final UAT doc - refer catechumen (acceptance)
      end
      
      # NOTE - rev 12 Okt 2016
      exist_classes = StudentAttendance.pluck(:weeklytimetable_details_id).uniq  #class of exist attend
      intake_id_of_exist_classes=Weeklytimetable.joins(:weeklytimetable_details).where('weeklytimetable_details.id IN(?)', exist_classes).pluck(:intake_id)
      #LIST (1)classes & (2)intakes -> that attendance NOT yet created - NEW Attendance (by class & by intake)
      #LIST (3)classes & (4)intakes -> attendance (already exist) - SEARCH existing attendance (by class & by intake)
      if current_user.college.code=='amsas'
        @schedule_list = WeeklytimetableDetail.where('subject IN(?)',topics_ids_this_prog).where.not(id: exist_classes).order(:subject)
      else
        @schedule_list = WeeklytimetableDetail.where('topic IN(?)',topics_ids_this_prog).where.not(id: exist_classes).order(:topic)
      end
      @intake_list2=@intake_list2.where.not(intake_id: intake_id_of_exist_classes)
      if is_admin==true
        @exist_timetable_attendances=WeeklytimetableDetail.where(id: exist_classes).map(&:subject_details)
      else
        @exist_timetable_attendances=WeeklytimetableDetail.where(id: exist_classes, lecturer_id: current_user.userable_id).map(&:subject_details)
      end
      @intake_list3=Student.joins(:student_attendances).where(intake_id: intake_id_of_exist_classes).order(course_id: :asc).map(&:intake_list).uniq
      
      # NOTE - user with Index pg access may create attendance by Intake, although some classes are not taught by him
      
      # NOTE - make sure student exist for classes (WT details) Or @intake_list3 won't include the corresponding Intake (coz rely on Student table: intake_id)
      
      @search = StudentAttendance.search(params[:q])
      #BELOW : order(:weeklytimetable_details_id) - added, when group by class, won't split up (continueos paging), unless different Intake
      if is_admin==true
	 @student_attendances = @search.result
      else
         @student_attendances = @search.result.search2(current_user).order(:weeklytimetable_details_id)
      end
      @student_attendances  = @student_attendances.page(params[:page]||1)
      @student_attendances_intake = @student_attendances.group_by{|x|x.student.intake_id}
    end # end for if position_exist
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @student_attendances }
    end
  end
  
  def new
    @student_attendance = StudentAttendance.new
  end
  
  def edit
    @student_attendance = StudentAttendance.find(params[:id])
  end
  
  # PUT /student_attendances/1
  # PUT /student_attendances/1.xml
  def create
    @student_attendance = StudentAttendance.new(student_attendance_params)
    respond_to do |format|
      if @student_attendance.save
        format.html { redirect_to(student_student_attendance_path(@student_attendance), :notice =>t('student.attendance.title')+t('actions.created')) }
        format.xml  { head :ok }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @student_attendance.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  # PUT /student_attendances/1
  # PUT /student_attendances/1.xml
  def update
    @student_attendance = StudentAttendance.find(params[:id])
    respond_to do |format|
      if @student_attendance.update(student_attendance_params)
        format.html { redirect_to(student_student_attendance_path(@student_attendance), :notice =>t('student.attendance.title')+t('actions.updated')) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @student_attendance.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  # DELETE /student_attendances/1
  # DELETE /student_attendances/1.xml
  def destroy
    @student_attendance = StudentAttendance.find(params[:id])
    @student_attendance.destroy
    respond_to do |format|
      format.html { redirect_to(student_student_attendances_url) }
      format.xml  { head :ok }
    end
  end
  
  def student_attendan_form
     if params[:ids]
      @student_attendances=StudentAttendance.where(id: params[:ids]).sort_by{|x|x.student.name}
    else
      @student_attendances = StudentAttendance.where(id: params[:sas])#@search.result
    end
    classes_count=@student_attendances.group_by(&:weeklytimetable_details_id).count
    respond_to do |format|
      format.pdf do
        pdf = Student_attendan_formPdf.new(@student_attendances, view_context, current_user.college, classes_count)
        send_data pdf.render, filename: "student_attendan_form-{Date.today}",
                              type: "application/pdf",
                              disposition: "inline"
      end
    end
  end
    
  def new_multiple
    @create_type = params[:new_submit]
    @classid = params["classid"]
    unless @classid.blank?
      @student_attendances = Array.new(5) { StudentAttendance.new }
      #view data accordingly - new_multiple.html.haml 
      @selected_class = WeeklytimetableDetail.find(@classid)
      if current_user.college.code=='amsas'
        @subject_name = @selected_class.weeklytimetable_subject.name 
        @programmeid = @selected_class.weeklytimetable_subject.root.id 
      else
        @subject_name = @selected_class.weeklytimetable_topic.parent.name 
        @programmeid = @selected_class.weeklytimetable_topic.root.id 
      end
      if current_user.college.code=='amsas'
        @iii=@selected_class.weeklytimetable.schedule_intake.siri_name
      else
        @iii = @selected_class.weeklytimetable.schedule_intake.monthyear_intake.strftime('%b %Y')
      end
      intake_id=@selected_class.weeklytimetable.intake_id
      #@student_intake = Student.where('course_id=? AND intake>=? AND intake <?',@programmeid,@iii,@iii.to_date+1.day)
      @student_intake=Student.where(course_id: @programmeid, intake_id: intake_id)
      @student_att_exist = StudentAttendance.where('weeklytimetable_details_id=?', @classid)
      @student_ids_att_exist = @student_att_exist.pluck(:student_id)
      #by intake column
      #@student_list = Student.where('course_id=? AND intake>=? AND intake <? and id NOT IN(?)',@programmeid,@iii,@iii.to_date+1.day, @student_ids_att_exist)
      #by intake_id column
      @student_list = Student.where(course_id: @programme_id.to_i, intake_id: intake_id)
      @student_listing = @student_list if @student_list.count > 0
      @student_listing = @student_intake if @student_list.count==0 && @student_ids_att_exist.count ==0 && @student_intake.count>0 
    else
      flash[:notice] = t('student.attendance.select_class')
      redirect_to student_student_attendances_path
    end
  end
  
  def new_multiple_intake
    current_roles=current_user.roles.pluck(:authname)
    @create_type = params[:new_submit]
    @intake = params["intake"]
    @student_attendances = Array.new(5) { StudentAttendance.new }
    @programme_id =@intake.split(",")[1]
    @iii=@intake.split(",")[0]   #(monthyear_intake value of Intake table) relation: Intake_id data from Student table
    @intake_list = Intake.where(programme_id: @programme_id, monthyear_intake: @iii.to_date)
    if @intake_list.count > 0
      @intake_of_prog_id = @intake_list.first.id
      topics_ids_this_prog = Programme.find(@programme_id).descendants.where(course_type: ['Topic', 'Subtopic']).map(&:id)
      #@schedule_list = WeeklytimetableDetail.where('topic IN(?)',topics_ids_this_prog).order(:topic)
      if current_roles.include?('developer') || current_roles.include?('administration') || current_roles.include?('student_attendances_module_admin') 
        @schedule_list = WeeklytimetableDetail.joins(:weeklytimetable).where('topic IN(?) and intake_id=?',topics_ids_this_prog, @intake_of_prog_id).order(:topic)
      else
        @schedule_list = WeeklytimetableDetail.joins(:weeklytimetable).where('topic IN(?) and intake_id=?',topics_ids_this_prog, @intake_of_prog_id).where(lecturer_id: current_user.userable_id).order(:topic)
      end
      #by intake column
      #@student_list = Student.where('course_id=? AND intake>=? AND intake <?',@programme_id.to_i,@iii.to_date,@iii.to_date+1.day)
      #by intake_id column
      @student_list = Student.where(course_id: @programme_id.to_i, intake_id: @intake_list.pluck(:id))
    else
      #weeklytimetable details must exist, whereby it's weeklytimetable contains intake_id (from INTAKE table)
      entered_item = Programme.find(@programme_id).programme_list+", "+t('student.attendance.intake')+" "+@iii.to_date.strftime('%b %Y')+" "
      redirect_to(student_student_attendances_path, :notice=>entered_item+t('student.attendance.intake_not_exist'))
    end
  end
  
  def create_multiple
    @create_type = params[:new_submit]
    if @create_type == t('student.attendance.create_by_class')   
      @new_type = "2"
      @student_attendances_all = params[:student_attendances]  
      @student_attendances = params[:student_attendances].values.collect {|student_attendance| StudentAttendance.new(student_attendance) }
      if @student_attendances.all?(&:valid?) 
        @student_attendances.each(&:save!)  # ref: to retrieve each value - http://railsforum.com/viewtopic.php?id=11557 (Dazen2 007-10-07 05:27:42) 
        flash[:notice] = t('student.attendance.multiple_created')
        redirect_to :action => 'index'
      else                       
        flash[:error] = t('student.attendance.data_invalid')
        render :action => 'new_multiple'
        flash.discard
      end

    elsif @create_type == t('student.attendance.create_by_intake')
      @new_type = "3"
      @intake = params["intake"]
      @student_attendances_all = params[:student_attendances]  
      @student_attendances = params[:student_attendances].values.collect {|student_attendance| StudentAttendance.new(student_attendance) }    
      if @student_attendances.all?(&:valid?) 
        @student_attendances.each(&:save!) # ref: to retrieve each value of --> http://railsforum.com/viewtopic.php?id=11557 (Dazen2 007-10-07 05:27:42)
        params[:student_attendance_ids] = @student_attendances.map(&:id)
        flash[:notice] = t('student.attendance.multiple_created')
        redirect_to :action => 'index'
      else      
        redirect_to(student_student_attendances_path(:programme_id => 1), :notice=> t('student.attendance.data_invalid'))
      end
    end
    
  end
  
  def edit_multiple
    studentattendanceids = params[:student_attendance_ids]
    unless studentattendanceids.blank? 
      @studentattendances = StudentAttendance.find(studentattendanceids)
      @studentattendances_group = @studentattendances.group_by{|x|x.student_id} 
      @time_slot_main_count = @studentattendances.group_by{|u|u.weeklytimetable_detail.get_time_slot}.count
      @studentattendances_group.each do |s,sa|
        @time_slot_each_count = sa.group_by{|u|u.weeklytimetable_detail.get_time_slot}.count 
        if @time_slot_each_count != @time_slot_main_count
          @time_slot_match ="no"
        end
      end
      
      if ((@studentattendances.count % @studentattendances_group.count) == 0) 
        if (@time_slot_match =="no")
          flash[:notice] = t('student.attendance.same_class_schedule')
          redirect_to student_student_attendances_path
        else
          if @time_slot_main_count > 6
            flash[:notice] = t('student.attendance.max_class_multiple_edit')
            redirect_to student_student_attendances_path
          else
            @student_count = @studentattendances.map(&:student_id).uniq.count
            edit_type = params[:student_attendance_submit_button]
            if edit_type == t('edit_checked') 
              ## continue multiple edit (including subject edit here) --> refer view (edit_multiple & form_multiple)
            end
          end 
        end
      else
        flash[:notice] = t('student.attendance.complete_combination')
        redirect_to student_student_attendances_path
      end
 
    end
  end
  
  
  def update_multiple
    #raise params.inspect
    submit_val = params[:applychange]
    @studentattendance_ids = params[:student_attendance_ids]	
    @attends = params[:attends] 
    @reasons = params[:reasons]
    @actions = params[:actions]
    @statuss = params[:statuss]
    @remarks = params[:remarks]
    @weeklytimetable_details_ids = params[:weeklytimetable_details_ids]
    @studentattendances = StudentAttendance.find(@studentattendance_ids)  
    @studentattendances_group = @studentattendances.group_by{|x|x.student_id} 
      
    #####
    if submit_val == 'Apply Schedule / Classes'
      if @weeklytimetable_details_ids != nil
        @studentattendances_group.each do |student_id, studentattendances|  asset = Asset.find(params[:asset_id])
          studentattendances.each_with_index do |studentattendance, no|
            studentattendance.weeklytimetable_details_id = @weeklytimetable_details_ids[no.to_s]
            studentattendance.save
          end
        end
      end

      respond_to do |format|
        format.html {render :action => "edit_multiple_intake"}
        flash[:notice] = "<b>Classes/Schedule</b> are selected/updated. You may view/print <b>Attendance Form </b>(c/w date & time slot). <br>To update <b>student attendance</b>, check/uncheck check boxes accordingly and click <b>submit</b>."
        format.xml  { head :ok }
        flash.discard
      end
    else
      ##### 
      #@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@  
 
      #start-for edit_multiple.html.erb--------
      if !@weeklytimetable_details_ids
	next2=0
	@studentattendances_group.each do |student_id, studentattendances|
	  studentattendances.sort_by{|u|[u.weeklytimetable_detail.get_date_day_of_schedule , u.weeklytimetable_detail.get_time_slot]}.each_with_index do |studentattendance, no2|
	    #studentattendance.attend=false
	    #studentattendance.reason=@reasons[(no2+next2).to_s]
	    #studentattendance.save!
	    if @attends[(no2+next2).to_s]!=""
	      studentattendance.attend=true
	    else
	      studentattendance.attend=false
	      studentattendance.reason=@reasons[(no2+next2).to_s]
	      studentattendance.action = @actions[(no2+next2).to_s]
              studentattendance.status = @statuss[(no2+next2).to_s]
              studentattendance.remark = @remarks[(no2+next2).to_s]
	    end
	    studentattendance.save!
	    if no2 == studentattendances.count-1 #2 
              next2 = next2+no2+1 
            end
	  end #end for studentattendance.sort_by...
        end #end for @studentattendances_group

      end
      #end-for edit_multiple.html.erb--------

      #start-for edit_multiple_intake.html.erb--------
      @next = 0
      if @weeklytimetable_details_ids != nil
        @studentattendances_group.each do |student_id, studentattendances|  
          studentattendances.each_with_index do |studentattendance, no|
            studentattendance.weeklytimetable_details_id = @weeklytimetable_details_ids[no.to_s]
            if @attends && @attends[(no+@next).to_s]!=nil   #if @attends && @attends[no.to_s]!=nil
              studentattendance.attend = true
            else
              studentattendance.attend = false
            end
            studentattendance.save 
            if no == studentattendances.count-1 #2 
              @next = @next+no+1 
            end 
          end
        end
      end
      #end-for edit_multiple_intake.html.erb--------
     
      flash[:notice] = t('student.attendance.multiple_updated')
      redirect_to student_student_attendances_path
      #@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
      
    end 
  end   #--end of def update_multiple
  

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_student_attendance
      @student_attendance = StudentAttendance.find(params[:id])
    end
    
    def set_schedule_student_list
      position_exist = @current_user.userable.positions
      if position_exist  
        lecturer_programme = @current_user.userable.positions[0].unit
        unless lecturer_programme.nil?
          programme = Programme.where('name ILIKE (?) AND ancestry_depth=?',"%#{lecturer_programme}%",0)  if !(lecturer_programme=="Pos Basik" || lecturer_programme=="Diploma Lanjutan")
        end
        unless programme.nil? || programme.count==0
          programme_id = programme.try(:first).try(:id)
          topics_ids_this_prog = Programme.find(programme_id).descendants.at_depth(3).map(&:id)
          @student_list = Student.where('course_id=?',programme_id )
        else
          topics_ids_this_prog = Programme.at_depth(3).map(&:id)  
          @student_list= Student.all
        end
        @schedule_list = WeeklytimetableDetail.where('topic IN(?)',topics_ids_this_prog).order(:topic)
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def student_attendance_params
      params.require(:student_attendance).permit(:student_id, :attend, :weeklytimetable_details_id, :reason, :action, :status, :remark, :college_id, {:data => []})
    end
 
end


