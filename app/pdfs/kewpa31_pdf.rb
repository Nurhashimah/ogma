class Kewpa31Pdf < Prawn::Document
  def initialize(asset_loss, view, lead)
    super({top_margin: 50, page_size: 'A4', page_layout: :portrait })
    @asset_losses = asset_loss
    @view = view
    @lead = lead
    font "Times-Roman"
    text "KEW.PA-31", :align => :right, :size => 16, :style => :bold
    move_down 20
    text "SIJIL HAPUS KIRA ASET ALIH KERAJAAN", :align => :center, :size => 14, :style => :bold
    move_down 40
    text "Mejuruk kelulusan Perbendaharaan Bil #{'.'*40} bertarikh 
    #{'.'*40} Aset berikut telah dihapuskira dan Daftar Harta Modal/Inventori berkenaan telah dikemaskini.", :align => :left, :size => 14
    move_down 20
    table1
    #move_down 500# - for testing 12May2015
    #minimum height required for last item+SIGNATORY
    if y < 250   #bounds.height - y > 100
      start_new_page
      table_heading
      table2
    else
      table2
    end
    blank_table if @asset_losses.count < 10 #5
    move_down 50
    cop
  end
  
  def table1
    table(line_item_rows,:column_widths => [30, 300, 150],  :cell_style => { :size => 12,  :inline_format => :true} )
  end
  
  def line_item_rows
    counter = counter || 0
    header = [[ 'Bil', 'Jenis Aset', 'No. Pendaftaran']]
    boddy=[]
      @asset_losses.each do |asset_loss|
      if counter < @asset_losses.count-1
      boddy<< ["#{counter += 1}", "#{asset_loss.try(:asset).try(:typename)} #{asset_loss.try(:asset).try(:name)} #{asset_loss.try(:asset).try(:modelname)}", " #{asset_loss.try(:asset).try(:assetcode)}  "  ]
      end
    end
     header+boddy
  end
  
  def table_heading
    heading = [[ 'Bil', 'Jenis Aset', 'No. Pendaftaran']]
    table(heading,:column_widths => [30, 300, 150],  :cell_style => { :size => 12,  :inline_format => :true})
  end
  
   def table2
    table(lastitem_row,:column_widths => [30, 300, 150],  :cell_style => { :size => 12,  :inline_format => :true} )
  end
  
  def lastitem_row
    ind_item=@asset_losses.count-1
    lastitemrow=[["#{ind_item}","#{@asset_losses[ind_item].try(:asset).try(:typename)} #{@asset_losses[ind_item].try(:asset).try(:name)} #{@asset_losses[ind_item].try(:asset).try(:modelname)}","#{@asset_losses[ind_item].try(:asset).try(:assetcode)}"]]
  end
  
  def blank_table
    table(blank_rows,:column_widths => [30, 300, 150],  :cell_style => { :size => 12,  :inline_format => :true} ) do
      cells.height=20
    end
  end
  
  def blank_rows
    counter=@asset_losses.count
    blank_row=[]
    while counter < 10
      blank_row << ["","",""]
      counter+=1
    end
    blank_row
  end
  
  def cop    
   data = [["Tandatangan Ketua Jabatan", ": "],
            ["Nama", ": #{@lead.try(:staff).try(:name)}"],
            ["Jawatan", ": #{@lead.name}"],
            ["Tarikh",": #{@asset_losses.try(:updated_at).try(:strftime, "%d/%m/%y")}"],
            ["Cop Kemeterian/Jabatan", ":"]]
            
    table(data,:column_widths => [150, 300])  do
         row(0).borders = [ ]
         row(0).height = 20
         row(1).borders = [ ]
         row(1).height = 20
         row(2).borders = [ ]
         row(2).height = 20
         row(3).borders = [ ]
         row(3).height = 20
         row(4).borders = [ ]
         row(4).height = 20
       end
   
  end
  
  
end