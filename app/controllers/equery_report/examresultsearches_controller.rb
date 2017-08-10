class EqueryReport::ExamresultsearchesController < ApplicationController
   filter_resource_access
  
  def new
    @examresultsearch = Examresultsearch.new
  end
  
  def create
    if @examresultsearch.save
        redirect_to equery_report_examresultsearch_path(@examresultsearch)
    else
        render :action => 'new'
    end
  end

  def show
    @examresultsearch = Examresultsearch.find(params[:id])
    if @examresultsearch.student_id==0
      @examresults=@examresultsearch.examresults.page(params[:page]).per(10)
    elsif @examresultsearch.student_id==1
      @examresults=@examresultsearch.examresults
      @arr = @examresults.map(&:resultlines).flatten
      @resultlines=Kaminari.paginate_array(@arr).page(params[:page]).per(10) 
    end
    
  end
   
  private
  
  # Never trust parameters from the scary internet, only allow the white list through.
    def examresultsearch_params
      params.require(:examresultsearch).permit(:intake_id, :subject_id, :student_id, :semester, :examdts, :examdte, :intake_programme, :college_id, [:data => {}])
    end
end
