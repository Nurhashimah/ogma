class LoginsController < ApplicationController
  def assign
    if params[:search].present? && params[:search][:icno].present?
      @login=Login.where(icno: params[:search][:icno].split(" | ")[0]).first
    end
  end
  
  def update
    @login = Login.find(params[:id])
    respond_to do |format|
      if @login.update(login_params)
	format.js
      else
        format.html { render :action => "assign" }
        format.xml  { render :xml => @login.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def show
  end
  
  private
  # Never trust parameters from the scary internet, only allow the white list through.
    def login_params
      params.require(:login).permit(:login, :icno, :isstaff, :is_deleted, :deleted_at)
    end
end
