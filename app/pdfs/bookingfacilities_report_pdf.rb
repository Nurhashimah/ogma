class Bookingfacilities_reportPdf < Prawn::Document
  def initialize(bookingfacilities, view, college)
    super({top_margin: 50, page_size: 'A4', page_layout: :portrait })
    @bookingfacilities = bookingfacilities
    @view = view
    @college=college
    font "Helvetica" #"Times-Roman"
    record
  end
  
  def record
    table(line_item_rows, :column_widths => [30,70, 145, 65, 90, 55,65], :cell_style => { :size => 9,  :inline_format => :true}, :header => 2) do
      row(0).borders =[]
      row(0).height=50
      row(0).style size: 11
      row(0).align = :center
      row(0..1).font_style = :bold
      row(1).background_color = 'FFE34D'
      self.row_colors = ["FEFEFE", "FFFFFF"]
      self.width = 520
      header = true
    end
  end
  
  def line_item_rows
    counter = counter || 0
    header = [[{content: " #{@college.name.upcase}<br>#{I18n.t('campus.bookingfacilities.list').upcase}", colspan: 7}],
                    ["No", I18n.t('campus.bookingfacilities.location_id'), I18n.t('campus.bookingfacilities.staff_id'), I18n.t('campus.bookingfacilities.request_date'), "#{I18n.t('campus.bookingfacilities.start_date')} - #{I18n.t('campus.bookingfacilities.end_date') }", I18n.t('campus.bookingfacilities.approval'), I18n.t('campus.bookingfacilities.approval2')]]
    header +
      @bookingfacilities.map do |bfacility|
      ["#{counter += 1}", "#{bfacility.booked_facility.location_list}", "#{bfacility.booking_staff.staff_with_rank} " , "#{bfacility.request_date.strftime('%d-%m-%Y')}"," #{bfacility.reservation_dates}", "#{bfacility.approval==true ? I18n.t('yes2') : I18n.t('no2')}",  "#{bfacility.approval2==true ? I18n.t('yes2') : I18n.t('no2')}"]
    end
  end
end