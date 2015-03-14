class Student::TenantsController < ApplicationController
  
  before_action :set_tenant, only: [:show, :edit, :update, :destroy]
  
  def index
    #@search = Tenant.where("student_id IS NOT NULL").search(params[:q])
    @search = Tenant.search(params[:q]) #NOTE: To match with room map, statistic (by programme) & census_level (+report)
    if params[:q]
      #move searches here
    end
    @search.keyreturned_present != nil unless params[:q]
    @search.force_vacate_true = false unless params[:q]
    @search.sorts = 'location_combo_code asc' if @search.sorts.empty?
    @tenants = @search.result

    respond_to do |format|
      format.html
      #format.xls - temp hide until resolve - 'general i/o error'
      format.csv { send_data @tenants.to_csv }
      format.xls { send_data @tenants.to_csv(col_sep: "\t") } 
    end
  end

  #Statistic (by level) & Census(links only)
  def reports
    #Listing of all levels in all blocks
    @places = Location.where('typename = ? OR typename =?', 2, 8)
    roots = []
    @places.each do |place|
     roots << place.root
    end
    @residentials = roots.uniq
    @current_tenants = Tenant.where("keyreturned IS ? AND force_vacate != ?", nil, true)
    @occupied_locations = @current_tenants.pluck(:location_id)
    
    #Excel - Statistic by level (of selected block) - moved to LOCATION module - statistic_level
  end
  
  #Census by level
  def census_level
    @floor_id = params[:id]
    @floor=Location.find(@floor_id) #103, 1181
    @all_beds_single=Location.find(params[:id]).descendants.where('typename = ? OR typename =?', 2, 8).sort_by{|y|y.combo_code}
    #@all_rooms=Location.find(params[:id]).descendants.where('typename = ?',6) #NOTE : error - not precise!
    @all_rooms=Location.find(params[:id]).descendants.where('typename = ? OR typename =?', 2, 8).pluck(:combo_code).group_by{|x|x[0, x.size-2]}
    @damaged_rooms=Location.find(params[:id]).descendants.where('typename = ? OR typename =?', 2, 8).where(occupied: true).pluck(:combo_code).group_by{|x|x[0, x.size-2]}
    @current_tenants = Tenant.where("keyreturned IS ? AND force_vacate != ?", nil, true)
    @tenantbed_per_level=Location.find(params[:id]).descendants.where('typename = ? OR typename =?', 2, 8).joins(:tenants).where("tenants.id" => @current_tenants)
    @occupied_rooms= @tenantbed_per_level.pluck(:combo_code).group_by{|x|x[0, x.size-2]}

    #Location.find(params[:id]).descendants.where('typename = ? OR typename =?', 2, 8).where('id iN(?)', @current_tenants.pluck(:location_id)).pluck(:combo_code).group_by{|x|x[0, x.size-2]}
    #must not be sorted
    #building.descendants.where(typename: [2,8]).joins(:tenants).where("tenants.id" => @current_tenants)
    
    #Excel - Census by level - moved to LOCATION module - census_level2
  end

  def room_map
    @residentials = Location.where(lclass: 4).order(combo_code: :asc)
    #sets div size to fit no of buildings
    @div_width = 90/@residentials.count
    @current_tenants = Tenant.where("keyreturned IS ? AND force_vacate != ?", nil, true)
    @occupied_locations = @current_tenants.pluck(:location_id)
  end

  def statistics
    @locations = Location.where('typename IN (?)', [2,8])
    @female_student_beds  = @locations.where('typename = ?', 2)
    @male_student_beds    = @locations.where('typename = ?', 8)
    @current_tenants = Tenant.where("keyreturned IS ? AND force_vacate != ?", nil, true)
    @occupied_locations = @current_tenants.pluck(:location_id)
    
    #All Rooms
     @af_bedcode = @female_student_beds.pluck(:combo_code)
     @am_bedcode = @male_student_beds.pluck(:combo_code)
     @am_rooms = @am_bedcode.group_by{|x|x[0, x.size-2]} #block A  {"HA-01-01"=>["HA-01-01-A", "HA-01-01-B"]} - group by male rooms (Block A)
     @af_rooms = @af_bedcode.group_by{|x|x[0, x.size-2]}   #block B & C {"HB-01-01"=>["HB-01-01-A", "HB-01-01-B"], "HC-01-01"=>["HC-01-01-A", "HC-01-01-B"]}
#     @bedF_B = @af_bedcode.group_by{|x|x[1,1]}["B"]     #bed by block {"B"=>["HB-01", "HB-01", "HB-02"], "C"=>["HC-01"]}
#     @bedF_C = @af_bedcode.group_by{|x|x[1,1]}["C"]
#     @roomF_B = @bedF_B.group_by{|x|x[0, x.size-2]}
#     @roomF_C = @bedF_C.group_by{|x|x[0, x.size-2]}

    #Occupied Rooms
     @of_bedcode = @female_student_beds.joins(:tenants).where("tenants.id" => @current_tenants).pluck(:combo_code)
     @om_bedcode = @male_student_beds.joins(:tenants).where("tenants.id" => @current_tenants).pluck(:combo_code)
     @of_rooms = @of_bedcode.group_by{|x|x[0, x.size-2]}
     @om_rooms = @om_bedcode.group_by{|x|x[0, x.size-2]}

    #Damaged Rooms
     @df_bedcode = @female_student_beds.where(occupied: true).pluck(:combo_code)
     @dm_bedcode = @male_student_beds.where(occupied: true).pluck(:combo_code)
     @df_rooms = @df_bedcode.group_by{|x|x[0, x.size-2]}
     @dm_rooms = @dm_bedcode.group_by{|x|x[0, x.size-2]}

    #For Statistics by Programme
    @places = Location.where('typename = ? OR typename =?', 2, 8)
    roots = []
    @places.each do |place|
     roots << place.root
    end
    @residentials = roots.uniq
    @current_tenants = Tenant.where("keyreturned IS ? AND force_vacate != ?", nil, true)
    @occupied_locations = @current_tenants.pluck(:location_id)
  end
  
  def return_key
    if params[:search] && params[:search][:student_icno].present?
      params[:id]=nil
      @student_ic = params[:search][:student_icno]
      @ic_only = @student_ic.split(" ")[0]
      #@selected_student = Student.where("icno = ?", "#{@student_ic}").first
      @my_room = Tenant.where(student_id: Student.where("icno = ?", "#{@ic_only}").first).first
    elsif params[:id]
      @icno = params[:id]
      @my_room = Tenant.where(student_id: Student.where("icno = ?", "#{@icno}").first).first
    end
    @tenant = @my_room
  end

  def new
    @current_tenant_ids = Tenant.where(:keyreturned => nil).where(:force_vacate => false).pluck(:student_id)
    @potential1=Student.where(gender: 1).where("end_training > ?", Date.today).pluck(:id)-@current_tenant_ids
    @potential2=Student.where(gender: 2).where("end_training > ?", Date.today).pluck(:id)-@current_tenant_ids
    @tenant = Tenant.new(:location_id => params[:location_id])
  end

  def edit
  end

  def create
    @tenant = Tenant.new(tenant_params)
    respond_to do |format|
      if @tenant.save
        flash[:notice] = (t 'student.tenant.title')+(t 'actions.created')
        format.html { redirect_to(student_tenant_path(@tenant)) }
        format.xml  { render :xml => @tenant, :status => :created, :location => @tenant }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @tenant.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @tenant.update(tenant_params)
        format.html { redirect_to student_tenant_path(@tenant), notice: (t 'location.title')+(t 'actions.updated')  }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @tenant.errors, status: :unprocessable_entity }
      end
    end
  end

  def show
  end
  
  #PDF for census_level
  def census
     @floor=Location.find(params[:id]) #103, 1181
     @all_beds_single=Location.find(params[:id]).descendants.where('typename = ? OR typename =?', 2, 8).sort_by{|y|y.combo_code}
     #@all_rooms=Location.find(params[:id]).descendants.where('typename = ?',6) #error - not precise
     @all_rooms=Location.find(params[:id]).descendants.where('typename = ? OR typename =?', 2, 8).pluck(:combo_code).group_by{|x|x[0, x.size-2]}
     @damaged_rooms=Location.find(params[:id]).descendants.where('typename = ? OR typename =?', 2, 8).where(occupied: true).pluck(:combo_code).group_by{|x|x[0, x.size-2]}
     @current_tenants = Tenant.where("keyreturned IS ? AND force_vacate != ?", nil, true)
     @tenantbed_per_level=Location.find(params[:id]).descendants.where('typename = ? OR typename =?', 2, 8).joins(:tenants).where("tenants.id" => @current_tenants)
     @occupied_rooms= @tenantbed_per_level.pluck(:combo_code).group_by{|x|x[0, x.size-2]}

     @all_tenants_wstudent = @current_tenants.joins(:location).where('location_id IN(?) and student_id IN(?)', @tenantbed_per_level.pluck(:id), Student.all.pluck(:id))
     @students_prog = Student.where('id IN (?)', @all_tenants_wstudent.pluck(:student_id)).group_by{|j|j.course_id}
     @all_tenants_wostudent = @current_tenants.joins(:location).where('location_id IN(?) and (student_id is null OR student_id NOT IN(?))', @tenantbed_per_level.pluck(:id), Student.all.pluck(:id))
    
    respond_to do |format|
      format.pdf do
	pdf = CensusStudentTenantsPdf.new(@all_beds_single,@all_rooms.count, @damaged_rooms.count,@occupied_rooms.count, @students_prog, @all_tenants_wstudent.count, @all_tenants_wostudent.count, @tenantbed_per_level.count, view_context)
        send_data pdf.render, filename: "census",
                              type: "application/pdf",
                              disposition: "inline"
      end
    end
  end

  #PDF for Index
  def tenant_report
    @search = Tenant.search(params[:q]) #NOTE: To match with room map, statistic (by programme) & census_level (+report)
    @search.keyreturned_present != nil unless params[:q]
    @search.force_vacate_true = false unless params[:q]
    @search.sorts = 'location_combo_code asc' if @search.sorts.empty?
    @tenants = @search.result
    respond_to do |format|
       format.pdf do
         pdf = Tenant_reportPdf.new(@tenants, view_context)
                   send_data pdf.render, filename: "tenant_report-{Date.today}",
                   type: "application/pdf",
                   disposition: "inline"
       end
     end
  end
  
  #PDF for Reports (Statistik Penginapan-level listing)
  def laporan_penginapan
    buildingname = params[:buildingname]
    @residential = Location.where('name LIKE (?) and lclass=?', "#{buildingname}", 4).first
    @current_tenants=Tenant.where("keyreturned IS ? AND force_vacate != ?", nil, true)
    respond_to do |format|
       format.pdf do
         pdf = Laporan_penginapanPdf.new(@residential, @current_tenants, view_context)
                   send_data pdf.render, filename: "laporan_penginapan-{Date.today}",
                   type: "application/pdf",
                   disposition: "inline"
       end
     end
  end

  #PDF for Statistic (general) - room status(part of laporan/statistik penginapan) & tenant programme
  def laporan_penginapan2
    blockid= params[:blockid]
    @residentials = Location.find(blockid).descendants.where('typename = ? OR typename =?', 2, 8)    #beds
    @current_tenants=Tenant.where("keyreturned IS ? AND force_vacate != ?", nil, true)
    respond_to do |format|
       format.pdf do
         pdf = Laporan_penginapan2Pdf.new(@residentials, @current_tenants, view_context)
                   send_data pdf.render, filename: "laporan_penginapan-{Date.today}",
                   type: "application/pdf",
                   disposition: "inline"
       end
     end
  end

  def destroy
    @tenant.destroy
    respond_to do |format|
      #format.html { redirect_to student_tenants_url }
      format.html { redirect_to room_map_student_tenants_path }
      format.json { head :no_content }
    end
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tenant
      @tenant = Tenant.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tenant_params
      params.require(:tenant).permit(:location_id, :staff_id, :student_id, :keyaccept, :keyexpectedreturn, :keyreturned, :force_vacate, :student_icno, damages_attributes: [:id, :description,:reported_on,:document_id,:location_id])
    end

end
