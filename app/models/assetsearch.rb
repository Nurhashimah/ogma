class Assetsearch < ActiveRecord::Base
#   attr_accessible :assetcode, :assettype, :name, :purchaseprice, :purchasedate, :startdate, :enddate, :category, :assignedto, :bookable, :loandate, :returndate, :location, :defect_asset,:defect_reporter,:defect_processor,:defect_process,:maintainable 
#   attr_accessible :purchaseprice2, :purchasedate2,:loandate2, :returndate2,:expectedreturndate, :expectedreturndate2
#   attr_accessible :maintname, :maintcode, :disposal, :disposaltype, :discardoption, :disposalreport, :disposalcert, :disposalreport2,:loss_start,:loss_end,:loss_cert,:loanedasset,:alldefectasset
#   #validates_numericality_of :purchaseprice, :message => "not a number"
#   attr_accessor :method, :datetype, :curryear, :locationtype, :defect_type,:persontype,:disposal_for_reports
  
  #:assetcode, :assettype, :name, :purchaseprice, :purchasedate, :startdate, :enddate, :category, :assignedto, :bookable, :loandate, :returndate, :location, :defect_asset, :defect_reporter, :defect_processor, :defect_process, :maintainable, :maintname, :maintcode, :disposal, :disposaltype, :discardoption, :disposalreport, :disposalcert, :disposalreport2, :loss_start, :loss_end, :loss_cert, :loanedasset, :alldefectasset, :purchaseprice2, :purchasedate2, :receiveddate, :receiveddate2, :loandate2, :returndate2, :expectedreturndate, :expectedreturndate2
  
  attr_accessor :datetype, :locationtype
  
  def assets
    @assets ||= find_assets
  end
  
  SEARCH_TYPE=[
    #display          #stored 
    ["2 & 3", 1],
    ["4 (Harta Modal / Fixed Asset)", 2],
    ["5 (Inventori / Inventory)", 3],
    ["6 (Pergerakan Aset : Peminjaman)", 4],
    ["7 (Penempatan Aset)", 5],
    ["8 (Laporan Tahunan Harta Modal & Inventori)", 6],
    ["9 (Aduan Kerosakan Aset Alih)", 7],
    ["13 (Senarai Aset Alih yang Memerlukan Penyelenggaraan)", 8],
    ["14 (Daftar Penyelenggaraan Harta Modal)", 9],
    ["16 (Perakuan Pelupusan (PEP) Aset Alih Kerajaan)", 10],
    ["17 (Laporan Lembaga Pemeriksa Aset Alih Kerajaan)", 11],
    ["18 (Sijil Penyaksian Pemusnahan Aset Alih Kerajaan)", 12],
    ["19 (Sijil Pelupusan Aset Alih Kerajaan)", 13],
    ["20 (Laporan Tahunan Pemusnahan Aset Alih Kerajaan)", 14],
    ["28 (Laporan Awal Kehilangan Aset Alih Kerajaan)", 15],
    ["30 (Laporan Akhir Kehilangan Aset Alih Kerajaan)", 16],
    ["31 (Sijil Hapus Kira Aset Alih Kerajaan)", 17]
  ]
  
  def render_search_type
    (Assetsearch::SEARCH_TYPE.find_all{|disp, value| value==search_type}).map{|disp, value| disp}[0]
  end
  
  private

  def find_assets
    Asset.where(conditions).order(orders)   
  end
  
  def assetcode_conditions
    #["assetcode =?", assetcode] unless assetcode.blank?    #OK -but did not work if only part of assetcode was entered
    ["assetcode ILIKE ?", "%#{assetcode}%"] unless assetcode.blank?   #ok 
  end
  
  def name_conditions
    ["name ILIKE ?", "%#{name}%"] unless name.blank?    #ok
    #["purchaseprice>=?", name] unless name.blank?      #ok 
  end

  def purchaseprice_conditions
    ["purchaseprice>=?", purchaseprice] unless purchaseprice.blank?      
  end

  def purchasedate_conditions
    ["purchasedate>=?", purchasedate] unless purchasedate.blank?
    #["purchasedate>=?", "2011-10-19"] unless purchasedate.blank?        #["purchasedate>=?", name] unless name.blank?        #ok
  end  
  
  def purchaseprice2_conditions
     ["purchaseprice<=?", purchaseprice2] unless purchaseprice2.blank?      
  end
  
  def purchasedate2_conditions
    ["purchasedate<=?", purchasedate2] unless purchasedate2.blank?
  end 
  
  def startdate_conditions
    ["purchasedate>=?", startdate] unless startdate.blank?
  end
  
  def enddate_conditions  #between 2 dates
    ["purchasedate<?", enddate] unless enddate.blank?
  end

  def receiveddate_conditions
    ["receiveddate>=?", receiveddate] unless receiveddate.blank?
  end
  
  def receiveddate2_conditions  #between 2 dates
    ["receiveddate<=?", receiveddate2] unless receiveddate2.blank?
  end
  
  #======FOR ASSET LOAN - KEWPA 6---
  #AND is_approved!=?
  #@loanable = AssetLoan.find(:all, :conditions => ['asset_id=? AND is_approved!=?',params[:id], false], :order=>'returned_on ASC')
  #=================================

  def loandate_conditions
    unless loandate.blank?
      ids=AssetLoan.where('loaned_on>=? AND is_approved!=?', loandate, false).pluck(:asset_id).uniq 
      if ids.count > 0
        a="id=?" 
        0.upto(ids.count-2) do |x|
          a+=" OR id=? "
        end
        ["("+a+")", ids] 
      else
        [" (id=?)", 0]  # NOTE - refer above
      end
      
    end
  end
  
  def loandate2_conditions
    unless loandate2.blank?
      ids=AssetLoan.where('loaned_on<=? AND is_approved!=?', loandate2, false).pluck(:asset_id).uniq 
      if ids.count > 0
        a="id=?" 
        0.upto(ids.count-2) do |x|
          a+=" OR id=? "
        end
        ["("+a+")", ids] 
      else
        [" (id=?)", 0]  # NOTE - refer above
      end
    end
  end
  
  def returndate_conditions
    unless returndate.blank?
      ids=AssetLoan.where('returned_on>=? AND is_approved!=?', returndate, false).pluck(:asset_id).uniq
      if ids.count > 0
        a="id=?" 
        0.upto(ids.count-2) do |x|
          a+=" OR id=? "
        end
        ["("+a+")", ids] 
      else
        [" (id=?)", 0]  # NOTE - refer above
      end
    end
  end
  
  def returndate2_conditions
    unless returndate2.blank?
      ids=AssetLoan.where('returned_on<=? AND is_approved!=?', returndate2, false).pluck(:asset_id).uniq
      if ids.count > 0
        a="id=?" 
        0.upto(ids.count-2) do |x|
          a+=" OR id=? "
        end
        ["("+a+")", ids] 
      else
        [" (id=?)", 0]  # NOTE - refer above
      end
    end
  end

  def expectedreturndate_conditions
    unless expectedreturndate.blank?
      ids=AssetLoan.where('expected_on>=? AND is_approved!=?', expectedreturndate, false).pluck(:asset_id).uniq
      if ids.count > 0
        a="id=?" 
        0.upto(ids.count-2) do |x|
          a+=" OR id=? "
        end
        ["("+a+")", ids] 
      else
        [" (id=?)", 0]  # NOTE - refer above
      end
    end
  end
  
  def expectedreturndate2_conditions
    unless expectedreturndate2.blank?
      ids=AssetLoan.where('expected_on<=? AND is_approved!=?', expectedreturndate2, false).pluck(:asset_id).uniq
      if ids.count > 0
        a="id=?" 
        0.upto(ids.count-2) do |x|
          a+=" OR id=? "
        end
        ["("+a+")", ids] 
      else
        [" (id=?)", 0]  # NOTE - refer above
      end
    end
  end

  def loanedasset_conditions
    if loanedasset==1
      ids=AssetLoan.pluck(:asset_id).uniq
      if ids.count > 0
        a="id=?" 
        0.upto(ids.count-2) do |x|
          a+=" OR id=? "
        end
        ["("+a+")", ids] 
      else
        [" (id=?)", 0]  # NOTE - refer above
      end
    end
  end
  
    
  #----newly added-30July2013
  #---tick to display all asset defect records---
  def alldefectasset_details
    a='id=? ' if AssetDefect.all.map(&:asset_id).uniq.count!=0
    0.upto(AssetDefect.all.map(&:asset_id).uniq.count-2) do |l|  
      a=a+'OR id=? '
    end
    return a if alldefectasset == 1 
  end
  
  def alldefectasset_conditions
    ["( "+ alldefectasset_details+")", AssetDefect.all.map(&:asset_id).uniq] if alldefectasset == 1
  end
  #----newly added-30July2013


  
  def assettype_conditions
     ["assettype =?", assettype] unless assettype.blank?
  end
  
  #def assignedtodetails
   # a='assignedto_id=? AND id=? ' if AssetDefect.all.map(&:asset_id).count!=0
    #0.upto(AssetDefect.all.map(&:asset_id).count-2) do |l|  
    #  a=a+'OR id=? '
    #end 
    #return a unless assignedto.blank?
  #end
  
  def assignedto_conditions 
    #if category == 5  #KEW-PA 7 (search by : assignedto)
        #["assignedto_id=?", assignedto] unless assignedto.blank? 
    #else              #KEW-PA 9 (search by : assignedto)
        #[assignedtodetails, assignedto,AssetDefect.all.map(&:asset_id)] unless assignedto.blank? 
    #end
    ["assignedto_id=?", assignedto] unless assignedto.blank?  #use this condition WITH FILTER FOR asset in ASSETDEFECT DB only - in show page.
  end

  #to include asset_placement records - KEWPA 7
  def category_conditions
    if category==1
      ids=AssetPlacement.joins(:asset).pluck(:asset_id).uniq.compact+Asset.where.not(location_id: nil).pluck(:id)
      if ids.count > 0
          a="id=?" 
          0.upto(ids.count-2) do |x|
            a+=" OR id=? "
          end
          ["("+a+")", ids] 
      else
          [" (id=?)", 0]  # NOTE - refer above
      end
    end
  end
  
  def location_conditions
    unless location.blank?
      assets_of_location=Asset.where(location_id: location)
      placements=AssetPlacement.joins(:asset)
      placements_of_location=placements.where(location_id: location)
      if assets_of_location.count > 0
        ["location_id=?", location] 
      elsif placements_of_location.count > 0
        ids=placements.pluck(:asset_id)
	if ids.count > 0
          a="id=?" 
          0.upto(ids.count-2) do |x|
            a+=" OR id=? "
          end
          ["("+a+")", ids] 
        else
          [" (id=?)", 0]  # NOTE - refer above
        end
      end
    end
  end
  
  def defect_asset_conditions
    ["id=?", AssetDefect.find(defect_asset).asset_id] unless defect_asset.blank? 
  end
  
  
  def defect_details
     a='id=? ' if AssetDefect.where('reported_by=?',defect_reporter).map(&:asset_id).uniq.count!=0
     0.upto(AssetDefect.where('reported_by=?',defect_reporter).map(&:asset_id).uniq.count-2) do |l|  
       a=a+'OR id=? '
     end 
     return a unless defect_reporter.blank?
  end
  

  
  def defect_reporter_conditions
    [defect_details, AssetDefect.find(:all, :conditions=>['reported_by=?',defect_reporter]).map(&:asset_id).uniq] unless defect_reporter.blank?
    #["id=?",31] unless defect_reporter.blank?
  end
  
  def defect_details2
      a='id=? ' if AssetDefect.where('processed_by=?',defect_processor).map(&:asset_id).uniq.count!=0
      0.upto(AssetDefect.where('processed_by=?',defect_processor).map(&:asset_id).uniq.count-2) do |l|  
        a=a+'OR id=? '
      end 
      return a unless defect_processor.blank?
  end

  def defect_processor_conditions
    [defect_details2, AssetDefect.where('processed_by=?',defect_processor).map(&:asset_id).uniq] unless defect_processor.blank?
    # ["id=?", AssetDefect.find(defect_processor).asset_id] unless defect_asset.blank?
  end
  
  #%%%%%%%%%%%%%%%%%%%%%%%%%
  def defectprocess_details
      a='id=? ' if AssetDefect.where('process_type=?',defect_process).map(&:asset_id).uniq.count!=0
      0.upto(AssetDefect.where('process_type=?',defect_process).map(&:asset_id).uniq.count-2) do |l|  
        a=a+'OR id=? '
      end 
      return a if defect_process=='dispose' || defect_process=='repair' #unless defect_process.blank?
  end  
  
  def defect_process_conditions    
    [defectprocess_details, AssetDefect.where('process_type=?',defect_process).map(&:asset_id).uniq] if defect_process=='dispose' || defect_process=='repair'    #unless defect_process.blank?
  end
  #%%%%%%%%%%%%%%%%%%%%%%%%%
  
  def maintainable_conditions
      ['is_maintainable is TRUE'] unless maintainable.blank?# && maintainable==false
  end
  
  def maintname_conditions
      ["is_maintainable is TRUE AND (name ILIKE ? OR typename ILIKE ? OR modelname ILIKE ?)", "%#{maintname}%", "%#{maintname}%", "%#{maintname}%"] unless maintname.blank? 
  end
  
  def maintcode_conditions
      ['is_maintainable is TRUE AND assetcode ILIKE ?', "%#{maintcode}%"] unless maintcode.blank?
  end
  
  def disposal_details
    a='id=? ' if AssetDisposal.all.map(&:asset_id).uniq.count!=0
    0.upto(AssetDisposal.all.map(&:asset_id).uniq.count-2) do |l|  
      a=a+'OR id=? '
    end 
    return a unless disposal.blank?
  end
  
  def disposal_conditions
      [" ("+disposal_details+")", AssetDisposal.all.map(&:asset_id).uniq] unless disposal.blank?
  end
  
  def disposalcert_details
    a='id=? ' if AssetDisposal.where('is_disposed is TRUE').map(&:asset_id).uniq.count!=0
    0.upto(AssetDisposal.where('is_disposed is TRUE').map(&:asset_id).uniq.count-2) do |l|  
      a=a+'OR id=? '
    end 
    return a unless disposalcert.blank?
  end
  
  def disposalcert_conditions
    [" ("+disposalcert_details+")", AssetDisposal.where('is_disposed is TRUE').map(&:asset_id).uniq] unless disposalcert.blank?
  end
  
  def disposalreport_details
    a='id=? ' if AssetDisposal.find(disposalreport.to_s.split(",")).map(&:asset_id).uniq.count!=0
    0.upto(AssetDisposal.find(disposalreport.to_s.split(",")).map(&:asset_id).uniq.count-2) do |l|  
      a=a+'OR id=? '
    end 
    return a unless disposalreport.blank?
  end  
  
  def disposalreport_conditions
    #['id=? OR id=?',AssetDisposal.find(discardoption.to_s.split(",")).map(&:asset_id)] unless discardoption.blank?
    [disposalreport_details,AssetDisposal.find(disposalreport.to_s.split(",")).map(&:asset_id).uniq] unless disposalreport.blank?
  end
  
  def disposalreport2_details
    a='id=? ' if AssetDisposal.find(disposalreport2.to_s.split(",")).map(&:asset_id).uniq.count!=0
    0.upto(AssetDisposal.find(disposalreport2.to_s.split(",")).map(&:asset_id).uniq.count-2) do |l|  
      a=a+'OR id=? '
    end 
    return a unless disposalreport2.blank?
  end  
  
  def disposalreport2_conditions
    [disposalreport2_details,AssetDisposal.find(disposalreport2.to_s.split(",")).map(&:asset_id).uniq] unless disposalreport2.blank?
  end
  
  def discardoption_details
    a='id=? ' if AssetDisposal.where('discard_options=?',discardoption).map(&:asset_id).uniq.count!=0
    0.upto(AssetDisposal.where('discard_options=?',discardoption).map(&:asset_id).uniq.count-2) do |l|  
        a=a+'OR id=? '
    end 
    return a unless discardoption.blank?
  end
  
  def discardoption_conditions
    [discardoption_details, AssetDisposal.where('discard_options=?',discardoption).map(&:asset_id).uniq] unless discardoption.blank?
  end
  
  def loss_start_details
    a='id=? ' if AssetLoss.all.map(&:asset_id).count!=0
    0.upto(AssetLoss.all.map(&:asset_id).count-2) do |l|  
      a=a+'OR id=? '
    end 
    return a if loss_start== 1 #unless loss_start.blank? 
  end  
  
  def loss_start_conditions
    [" ("+loss_start_details+")",AssetLoss.all.map(&:asset_id)] unless loss_start.blank?
  end
  
  def loss_end_details
    a='id=? ' if AssetLoss.where('endorsed_on IS NOT NULL').map(&:asset_id).count!=0
    0.upto(AssetLoss.where('endorsed_on IS NOT NULL').map(&:asset_id).count-2) do |l|  
      a=a+'OR id=? '
    end 
    return a unless loss_end.blank?
  end  
  
  def loss_end_conditions
    [" ("+loss_end_details+")",AssetLoss.where('endorsed_on IS NOT NULL').map(&:asset_id)] unless loss_end.blank?
  end
  
  def loss_cert_details
    a='id=? ' if AssetLoss.where('document_id=?', loss_cert).map(&:asset_id).uniq.count!=0
    0.upto(AssetLoss.where('document_id=?', loss_cert).map(&:asset_id).uniq.count-2) do |l|  
      a=a+'OR id=? '
    end 
    return a unless loss_cert.blank?
  end
  
  def loss_cert_conditions
    [loss_cert_details,AssetLoss.where('document_id=?', loss_cert).map(&:asset_id)] unless loss_cert.blank?
  end
  
  #def disposaltype_details
    #a='id=? ' if AssetDisposal.find(:all, :conditions=>['disposal_type=?', disposaltype]).map(&:asset_id).uniq.count!=0
    #0.upto(AssetDisposal.find(:all, :conditions=>['disposal_type=?', disposaltype]).map(&:asset_id).uniq.count-2) do |l|  
        #a=a+'OR id=? '
    #end 
    #return a unless disposaltype.blank?
  #end
  
  #def disposaltype_conditions
   # [disposaltype_details, AssetDisposal.find(:all, :conditions=>['disposal_type=?',disposaltype]).map(&:asset_id)] unless disposaltype.blank?
  #end
    
  def orders
    "assetcode ASC"# "staffgrade_id ASC"
  end  

  def conditions
    [conditions_clauses.join(' AND '), *conditions_options] #works like OR?????
  end

  def conditions_clauses
    conditions_parts.map { |condition| condition.first }
  end

  def conditions_options
    conditions_parts.map { |condition| condition[1..-1] }.flatten
  end

  def conditions_parts
    private_methods(false).grep(/_conditions$/).map { |m| send(m) }.compact
  end
 
end
