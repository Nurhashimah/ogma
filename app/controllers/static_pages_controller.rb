class StaticPagesController < ApplicationController
  helper Notifications

  def home
   @bulletins = Bulletin.order(publishdt: :desc).limit(10)
   #RE-activate when domain name is READY-17Nov2016 # @college=College.find_by_code!(request.subdomain(2))
   @college=College.where(code: 'amsas').first #HIDE this line when domain name is READY-17Nov2016
  end
  
  def landing
    @colleges=College.all
  end

  def help
  end

  def about
  end

  def contact
  end

  def dashboard
   @bulletins = Bulletin.order(publishdt: :desc).limit(10)
    if user_signed_in?
    else
      redirect_to("http://#{request.host}:3003", notice: (t 'user.sign_in_required')) 
    end
  end
  
#   def equery_reports
#     unless params[:query_module].blank?
#       @query_module=params[:query_module]
#     end
#   end
  
  def equery_staff
  end
  
  def equery_assets
  end
  
  def efiling
  end
  
  def student
  end
  
  def training
  end
  
  def examination
  end
  
  def library
  end
  
  def repository
  end
  
end
