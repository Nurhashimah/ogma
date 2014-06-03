class Asset::AssetDisposalsController < ApplicationController
  before_action :set_disposed, only: [:show, :edit, :update, :destroy]
  
  def index
    @disposals = AssetDisposal.order(code: :asc).page(params[:page]||1)
  end
  
  def show
  end
  
  def kewpa17
    @disposal = AssetDisposal.find(:all, :order => 'created_at DESC')
    respond_to do |format|
      format.pdf do
        pdf = Kewpa17df.new(@disposal, view_context)
        send_data pdf.render, filename: "kewpa17-{Date.today}",
                              type: "application/pdf",
                              disposition: "inline"
      end
    end
  end
  def kewpa20
    @disposal = AssetDisposal.find(:all, :order => 'created_at DESC')
    respond_to do |format|
      format.pdf do
        pdf = Kewpa20df.new(@disposal, view_context)
        send_data pdf.render, filename: "kewpa20-{Date.today}",
                              type: "application/pdf",
                              disposition: "inline"
      end
    end
  end
  
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_disposed
      @disposed = AssetDisposal.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def asset_disposal_params
      params.require(:asset_disposal).permit(:code, :category, :unittype, :maxquantity, :minquantity, damages_attributes: [:id, :description,:reported_on,:document_id,:location_id])
    end
end