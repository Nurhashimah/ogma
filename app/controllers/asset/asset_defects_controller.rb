class Asset::AssetDefectsController < ApplicationController
  before_action :set_defective, only: [:show, :edit, :update, :destroy]
  
  def index
    @search = AssetDefect.where.not(decision: true).search(params[:q])
    @assets = @search.result
    @defective = @assets.order(created_at: :desc).page(params[:page]||1)
  end
  
  def show
  end
  
  def new
    @asset = Asset.find(params[:asset_id])
    @asset_defect = @asset.asset_defects.new(params[:asset_defect])
    #@damage.save
    
  end
  
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_defective
      @asset_defect = AssetDefect.find(params[:id])
      @defective = @asset_defect
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def asset_defect_params
      params.require(:asset_defect).permit(:description, damages_attributes: [:id, :description,:reported_on,:document_id,:location_id])
    end
end

# == Schema Information
#
# Table name: asset_defects
#
#  asset_id       :integer
#  created_at     :datetime
#  decision       :boolean
#  decision_by    :integer
#  decision_on    :date
#  description    :text
#  id             :integer          not null, primary key
#  is_processed   :boolean
#  notes          :text
#  process_type   :string(255)
#  processed_by   :integer
#  processed_on   :date
#  recommendation :text
#  reported_by    :integer
#  updated_at     :datetime