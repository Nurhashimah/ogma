class Staff::RanksController < ApplicationController
   filter_access_to :index, :new, :create,:attribute_check => false
   filter_access_to :show, :edit, :update, :destroy, :attribute_check => true
  
  def index
    if current_user.college.name.include?("AMSAS")
      @search=Rank.where('name ilike(?)', "%Maritim%").search(params[:q])
    elsif current_user.college.name.include?("RMN")
      @search=Rank.where('data!=?',"").search(params[:q])
    else
      @search=Rank.where.not('name ILIKE(?)', "%Maritim%").where(data: "").search(params[:q])
    end
    @ranks=@search.result.order(id: :asc).page(params[:page]||1)
  end
  
  def new
    @rank=Rank.new
  end
  
  def edit
    @rank=Rank.find(params[:id])
  end
  
  def create
    @rank=Rank.new(rank_params)
    respond_to do |format|
      if @rank.save
        format.html { redirect_to staff_ranks_url, notice: (t 'rank.title')+(t 'actions.created')  }
        format.json { render action: 'show', status: :created, location: @rank }
      else
        format.html { render action: 'new' }
        format.json { render json: @rank.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def update
    @rank=Rank.find(params[:id])
    respond_to do |format|
      if @rank.update(rank_params)
        format.html { redirect_to staff_ranks_url, notice: (t 'rank.title')+(t 'actions.updated')  }
        format.json { render action: 'show', status: :created, location: @rank }
      else
        format.html { render action: 'new' }
        format.json { render json: @rank.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def show
  end
  
  def destroy
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_rank
      @rank = Rank.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def rank_params
      params.require(:rank).permit(:name, :category, :employgrade_id, :shortname, :college_id,{:data=> []}, :rate)
    end
  
end