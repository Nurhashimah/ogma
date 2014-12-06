class Student::StudentAttendancesController < ApplicationController
  before_action :set_student_attendance, only: [:show, :edit, :update, :destroy]

  # GET /student_attendances
  # GET /student_attendances.xml
  def index
    position_exist = @current_user.userable.positions
    @programme_list_ids = Programme.roots.pluck(:id)
    if position_exist  
      lecturer_programme = @current_user.userable.positions[0].unit
      unless lecturer_programme.nil?
        programme = Programme.where('name ILIKE (?) AND ancestry_depth=?',"%#{lecturer_programme}%",0)  if !(lecturer_programme=="Pos Basik" || lecturer_programme=="Diploma Lanjutan")
      end
      unless programme.nil? || programme.count==0
        @programme_id = programme.try(:first).try(:id)
        @intake_list2 = Student.where('course_id=?',@programme_id).select("DISTINCT intake, course_id").order(:intake) 
        @topics_ids_this_prog = Programme.find(@programme_id).descendants.at_depth(3).map(&:id)
        @student_ids = Student.where('course_id=?',@programme_id).pluck(:id)
      else
        @intake_list2 = Student.where('course_id IS NOT NULL and course_id IN(?)',@programme_list_ids).select("DISTINCT intake, course_id").order("course_id, intake") 
        @topics_ids_this_prog = Programme.at_depth(3).map(&:id)  
        @student_ids = Student.all.pluck(:id)
      end
      @schedule_list = WeeklytimetableDetail.where('topic IN(?)',@topics_ids_this_prog).order(:topic)
      
      #for ALL existing student attendance (BY CLASS/SCHEDULE)
      @exist_attendances = StudentAttendance.all.map(&:weeklytimetable_details_id).uniq 
      @exist_timetable_attendances_raw = WeeklytimetableDetail.where('id IN (?) and id IN(?)', @exist_attendances, @schedule_list.pluck(:id))
      @exist_timetable_attendances=[]
      @exist_timetable_attendances_raw.each do |x|
        @exist_timetable_attendances << [x.subject_day_time, x.id]
      end
      #-----
      #for ALL existing student attendance (BY INTAKE)
      @intake_list3=[]
      @exist_attendance_students = StudentAttendance.all.map(&:student_id).uniq
      @exist_intake_attendances_raw = Student.where('id IN(?) and id IN(?)', @exist_attendance_students, @student_ids).select("DISTINCT intake, course_id").order(:intake) 
      @exist_intake_attendances_raw.sort_by(&:course_id).each do |y|
        @intake_list3 << [(y.intake.strftime("%b %Y")+" "+Programme.where(id: y.course_id).first.name), (y.intake.to_s+","+y.course_id.to_s)]
      end
      #----
      
      @search = StudentAttendance.search(params[:q])
      @student_attendances = @search.result
      @student_attendances  = @student_attendances.page(params[:page]||1)
      @student_attendances_intake = @student_attendances.group_by{|x|x.student.intake}
      
    end # end for if position_exist
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @student_attendances }
    end
  end
  
  def new
  end
  
  def edit
    @student_attendance = StudentAttendance.find(params[:id])
  end
    
  def new_multiple
  end
  
  #def edit_multiple
  #end
  

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_student_attendance
      @student_attendance = StudentAttendance.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def student_attendance_params
      params.require(:student_attendance).permit(:student_id, :attend, :weeklytimetable_details_id, :reason, :action, :status, :remark)
    end
 
end

