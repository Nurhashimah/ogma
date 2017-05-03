class RepositoriesController < ApplicationController
  #filter_resource_access
  filter_access_to :index, :new, :create, :index2, :new2, :repository_list, :repository_list2, :attribute_check => false
  filter_access_to :show, :edit, :update, :destroy, :download, :attribute_check => true
  before_action :set_repository, only: [:show, :edit, :update, :destroy, :download]

  # GET /repositories
  # GET /repositories.xml
  def index
    @search=Repository.where.not(category: nil).search(params[:q])
    @repositories=@search.result.order(category: :asc)
    @repositories=@repositories.page(params[:page]||1)
    @exist_in_syst=Repository.where('title ILIKE(?) OR title ILIKE(?) OR title ILIKE(?) OR title ILIKE(?) OR title ILIKE(?) OR title ILIKE(?) ', '%penilaian diri untuk jurulatih%', '%PENILAIAN ANALISA SKOR PURATA JURULATIH%', '%PENILAIAN PENSYARAH%', '%DATA ANALISA SKOR PURATA PENILAIAN PENSYARAH%', '%KEDIAMAN ASRAMA%', '%MAKLUMAT PERIBADI%')
    @exist_in_syst+=Repository.where('title ILIKE (?) OR title ILIKE(?)', '%PENGGUNAAN PINJAMAN LATIHAN%', '%RANCANGAN LATIHAN MINGGUAN%')
    @access=[staff_instructor_appraisals_path, staff_average_instructors_path, exam_evaluate_courses_path, exam_evaluate_courses_path, student_tenants_path, students_path, asset_loans_path, training_weeklytimetables_path]
  end
  
  def index2
    @search=Repository.digital_library.search(params[:q])
    @repositories=@search.result.sort_by{|x|[x.document_type, x.document_subtype, x.vessel]}
    @repositories=Kaminari.paginate_array(@repositories).page(params[:page]||1)
  end

  # GET /repositories/1
  # GET /repositories/1.xml
  def show
  end

  # GET /repositories/new
  # GET /repositories/new.xml
  def new
    @repository=Repository.new
  end
  
  def new2
    @repository=Repository.new
  end

  # GET /repositories/1/edit
  def edit
    @repository=Repository.find(params[:id])
  end

  # POST /repositories
  # POST /repositories.xml
  def create
    @repository = Repository.new(repository_params)
    
    respond_to do |format|
      if @repository.save
        doc_title=@repository.data.blank? ? (t 'repositories.title') : (t 'repositories.title2')
        format.html { redirect_to @repository, notice: doc_title+t('actions.created')}
        format.json { render action: 'show', status: :created, location: @repository}
      else

        # NOTE - 20Apr2017 - workaround - to retrieve missing uploaded file when validation fails!  - start ####
        unless params[:repository][:uploaded].blank?                 # File field (uploaded) contains data (submission done with file SELECTION)
          upload_cache = AttachmentUploader.new                      # 1st submission -> save data in AttachmentUploader & set value for 'uploadcache' field
          upload_cache.data = repository_params[:uploaded]      # subsequent submission -> use 'uploadcache' field in form.
          if upload_cache.valid?
            upload_cache.msgnotification_id=0
            upload_cache.upload_for="repository"
            upload_cache.save
          end
          @aa=upload_cache.id
        end
        ######## - workaround ends here - NOTE - to refer model/attachment_uploader.rb & repository.rb, plus repositories/_form

        if @repository.data.blank?
          format.html { render action: 'new' }
          format.json { render json: @repository.errors, status: :unprocessable_entity }
        else
          format.html { render action: 'new2'}
        end

      end
    end
  end

  # PUT /repositories/1
  # PUT /repositories/1.xml
  def update
    @repository=Repository.find(params[:id])
    respond_to do |format|
      if @repository.update(repository_params)
        doc_title=@repository.data.blank? ? (t 'repositories.title') : (t 'repositories.title2')
        format.html { redirect_to @repository, notice: doc_title+t('actions.updated') }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @repository.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /repositories/1
  # DELETE /repositories/1.xml
  def destroy
    respond_to do |format|
      if @repository.data.blank?
        @repository.destroy
        format.html { redirect_to repositories_url }
      else
        @repository.destroy
        format.html { redirect_to index2_repositories_url }
      end
      format.json { head :no_content }
    end
  end

  def download
    #url=/assets/uploads/1/original/BK-KKM-01-01_BORANG_PENILAIAN_KURSUS.pdf?1474870599
    send_file("#{::Rails.root.to_s}/public#{@repository.uploaded.url.split("?").first}")
  end
  
  
  def repository_list
    @search = Repository.where.not(category: nil).search(params[:q])
    @repositories = @search.result
    respond_to do |format|
      format.pdf do
        pdf = Repository_listPdf.new(@repositories, view_context, current_user.college)
        send_data pdf.render, filename: "repository_list-{Date.today}",
                               type: "application/pdf",
                               disposition: "inline"
      end
    end
  end
  
  def repository_list2
    if params[:ids]
      @repositories=Repository.digital_library.where(id: params[:ids])
    else
      @search=Repository.digital_library.search(params[:q])
      @repositories = @search.result
    end
    @repositories=@repositories.sort_by{|x|[x.document_type, x.document_subtype, x.vessel]}
    respond_to do |format|
      format.pdf do
        pdf = Repository_list2Pdf.new(@repositories, view_context, current_user.college)
        send_data pdf.render, filename: "repository_list2-{Date.today}",
                               type: "application/pdf",
                               disposition: "inline"
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_repository
      @repository = Repository.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def repository_params
      params.require(:repository).permit(:id, :title, :staff_id, :category, :created_at, :updated_at, :uploaded, :uploaded_file_name, :uploaded_content_type, :uploaded_file_size, :uploadcache, :uploaded_updated_at, :vessel, :document_type, :document_subtype, :refno, :publish_date, :total_pages, :copies, :location, :classification, :code, :college_id, {:data => []})
    end
end
