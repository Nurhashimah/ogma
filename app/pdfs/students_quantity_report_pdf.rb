class Students_quantity_reportPdf < Prawn::Document 
  def initialize(programmes, students, view)
    super({top_margin: 40, page_size: 'A4', page_layout: :landscape })
    @programmes = programmes
    @students = students
    @view = view
    @students_course_id=students.pluck(:course_id).uniq
    @programmes_rev=@programmes.where('id IN (?)', @students_course_id)
    @intake1=(Student.get_intake(1, 1,@programmes.where(course_type: "Diploma")[0].id)).try(:strftime, "%b '%y")
    @intake2=(Student.get_intake(2, 1,@programmes.where(course_type: "Diploma")[0].id)).try(:strftime, "%b '%y")
    @intake3=(Student.get_intake(1, 2,@programmes.where(course_type: "Diploma")[0].id)).try(:strftime, "%b '%y")
    @intake4=(Student.get_intake(2, 2,@programmes.where(course_type: "Diploma")[0].id)).try(:strftime, "%b '%y")
    @intake5=(Student.get_intake(1, 3,@programmes.where(course_type: "Diploma")[0].id)).try(:strftime, "%b '%y")
    @intake6=(Student.get_intake(2, 3,@programmes.where(course_type: "Diploma")[0].id)).try(:strftime, "%b '%y")
    @intake_1=(Student.get_intake(1, 1,@programmes.where(course_type: ["Diploma Lanjutan", "Pos Basik"])[0].id)).try(:strftime, "%b '%y")
    @intake_2=(Student.get_intake(2, 1,@programmes.where(course_type: ["Diploma Lanjutan", "Pos Basik"])[0].id)).try(:strftime, "%b '%y")
    
    @table_heading=[ [{content: "BIL", rowspan: 4}, {content: "JENIS PROGRAM/ KURSUS", rowspan: 4}, {content: "KAPASITI", colspan: 2, rowspan: 2}, {content: "JANTINA", rowspan:4}, {content: "SESI PENGAMBILAN", colspan: 17}],[{content: "#{@intake1}", colspan:2}, {content: "#{@intake2}", colspan:2}, {content: "#{@intake3}", colspan:2}, {content: "#{@intake4}", colspan:2}, {content: "#{@intake5}", colspan:2}, {content: "#{@intake6}", colspan:2}, {content: "#{@intake_1}", colspan:2}, {content: "#{@intake_2}", colspan:2}, {content: "JUM PELATIH MENGIKUT SEM", rowspan: 3}],[{content: "KAPASITI KOLEJ", rowspan: 2},{content: "KAPASITI MENGIKUT PROGRAM",rowspan:2},{content: "Tahun 1", colspan:4},{content: "Tahun 2", colspan:4},{content: "Tahun 3", colspan:4},{content: "KPSL", colspan:4}],["Lapor Diri","Sem 1","Lapor Diri","Sem 2","Lapor Diri","Sem 1","Lapor Diri","Sem 2","Lapor Diri","Sem 1","Lapor Diri","Sem 2","Lapor Diri","Sem 1","Lapor Diri","Sem 2"] ]
    
    heading
    move_down 10
    record
    move_down 5
    cop
    
    if @programmes_rev.count>5
      start_new_page
      heading
      move_down 10
      record1b
      move_down 5
      cop
    end
    
    if @programmes_rev.count>9
      start_new_page
      heading
      move_down 10
      record1c
      move_down 5
      cop
    end
    
    if @programmes_rev.count>14
      start_new_page
      heading
      move_down 10
      record1d
      move_down 5
      cop
    end
    
  end
  
  def heading
    font "Times-Roman"
    image "#{Rails.root}/app/assets/images/logo_kerajaan.png", :position => :center, :scale => 0.45
    text "BAHAGIAN PENGURUSAN LATIHAN", :align => :center, :size => 10, :style => :bold
    text "KEMENTERIAN KESIHATAN MALAYSIA", :align => :center, :size => 10, :style => :bold
    move_down 5
    text "BILANGAN PELATIH DI INSTITUSI LATIHAN KEMENTERIAN KESIHATAN MALAYSIA", :align => :center, :size => 10, :style => :italic
    move_down 5
    if Date.today.month < 7
    text "INSTITUSI LATIHAN : KOLEJ SAINS KESIHATAN BERSEKUTU JOHOR BAHRU                                                                             **SESI:JAN-JUN #{Date.today.year}  JUL-DIS.......", :align => :left, :size => 10, :style => :bold
    else
    text "INSTITUSI LATIHAN : KOLEJ SAINS KESIHATAN BERSEKUTU JOHOR BAHRU                                                                             **SESI:JAN-JUN......  JUL-DIS #{Date.today.year}", :align => :left, :size => 10, :style => :bold
    end
  end
  
  def record
    table(line_item_rows, :column_widths => [23,60,45,50,45,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,55], :cell_style => { :size => 8,  :inline_format => :true}) do
      row(0..1).font_style = :bold
      row(0..3).background_color = 'FFE34D'
      row(0..1).align = :center
      column(2..21).align =:center
      self.row_colors = ["FEFEFE", "FFFFFF"]
      self.header = true
      self.width = 758#775
      header = true
    end
  end
  
  def line_item_rows
    counter = counter || 0
    header =@table_heading
    
    lines=[]
    @programmes_rev.each_with_index do |programme, counter|
       
       if programme.course_type=="Diploma"
         students_all_6intakes = Student.get_student_by_6intake(programme.id)
         @students_6intakes_ids = students_all_6intakes.map(&:id)
         @valid = Student.where('course_id=? AND race2 IS NOT NULL AND id IN(?)',programme.id, @students_6intakes_ids)
       else
         student_all_2intakes = Student.get_student_by_2intake(programme.id)
         @student_all_2intakes_ids = student_all_2intakes.map(&:id)
         @valid = Student.where('course_id=? AND race2 IS NOT NULL AND id IN(?)',programme.id, @students_2intakes_ids) #[]
       end

       if counter < 5
          lines<< [{content: "#{counter+=1}", rowspan:2}, {content: "#{programme.programme_list}", rowspan: 2},"","" ,"P","", "#{Student.get_student_by_intake_gender(1, 1, 2,programme.id).count if programme.course_type=="Diploma"}", "","#{@students.get_student_by_intake_gender(2, 1, 2,programme.id).count if programme.course_type=="Diploma"}", "","#{@students.get_student_by_intake_gender(1, 2, 2,programme.id).count if programme.course_type=="Diploma"}", "","#{@students.get_student_by_intake_gender(2, 2, 2,programme.id).count if programme.course_type=="Diploma"}", "","#{@students.get_student_by_intake_gender(1, 3, 2,programme.id).count if programme.course_type=="Diploma"}", "","#{@students.get_student_by_intake_gender(2, 3, 2,programme.id).count if programme.course_type=="Diploma"}", "","#{@students.get_student_by_intake_gender(1, 1, 2,programme.id).count if programme.course_type=="Diploma Lanjutan" ||programme.course_type=="Pos Basik"}", "","#{@students.get_student_by_intake_gender(2, 1, 2,programme.id).count if programme.course_type=="Diploma Lanjutan" || programme.course_type=="Pos Basik"}",{content: "#{@valid.count}", rowspan:2}]
          lines << [ "","","L","","#{Student.get_student_by_intake_gender(1, 1, 1,programme.id).count if programme.course_type=="Diploma"}","","#{@students.get_student_by_intake_gender(2, 1, 1,programme.id).count  if programme.course_type=="Diploma"}","","#{@students.get_student_by_intake_gender(1, 2, 1,programme.id).count if programme.course_type=="Diploma"}","","#{@students.get_student_by_intake_gender(2, 2, 1,programme.id).count if programme.course_type=="Diploma"}","","#{@students.get_student_by_intake_gender(1, 3, 1,programme.id).count if programme.course_type=="Diploma"}","","#{@students.get_student_by_intake_gender(2, 3, 1,programme.id).count if programme.course_type=="Diploma"}","","#{@students.get_student_by_intake_gender(1, 1, 1,programme.id).count if programme.course_type=="Diploma Lanjutan" ||programme.course_type=="Pos Basik"}","","#{@students.get_student_by_intake_gender(2, 1, 1,programme.id).count if programme.course_type=="Diploma Lanjutan" ||programme.course_type=="Pos Basik"}"]
       end
     end 
     header+lines
  end 
  
    def record1b
    table(line_item_rows1b, :column_widths =>  [23,60,45,50,45,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,55], :cell_style => { :size => 8,  :inline_format => :true}) do
      row(0..1).font_style = :bold
      row(0..3).background_color = 'FFE34D'
      row(0..1).align = :center
      column(2..21).align =:center
      self.row_colors = ["FEFEFE", "FFFFFF"]
      self.header = true
      self.width = 758
      header = true
    
    lines=[]
    end
  end
  
  def line_item_rows1b
    counter = counter || 0
    header=@table_heading
    
    lines=[]
    @programmes_rev.each_with_index do |programme, counter|
      
        if programme.course_type=="Diploma"
         students_all_6intakes = Student.get_student_by_6intake(programme.id)
         @students_6intakes_ids = students_all_6intakes.map(&:id)
         @valid = Student.where('course_id=? AND race2 IS NOT NULL AND id IN(?)',programme.id, @students_6intakes_ids)
       else
         student_all_2intakes = Student.get_student_by_2intake(programme.id)
         @student_all_2intakes_ids = student_all_2intakes.map(&:id)
         @valid = Student.where('course_id=? AND race2 IS NOT NULL AND id IN(?)',programme.id, @students_2intakes_ids) #[]
       end
       
       if counter > 4 && counter < 10
          lines<< [{content: "#{counter+=1}", rowspan:2}, {content: "#{programme.programme_list}", rowspan: 2},"","" ,"P","", "#{Student.get_student_by_intake_gender(1, 1, 2,programme.id).count if programme.course_type=="Diploma"}", "","#{@students.get_student_by_intake_gender(2, 1, 2,programme.id).count if programme.course_type=="Diploma"}", "","#{@students.get_student_by_intake_gender(1, 2, 2,programme.id).count if programme.course_type=="Diploma"}", "","#{@students.get_student_by_intake_gender(2, 2, 2,programme.id).count if programme.course_type=="Diploma"}", "","#{@students.get_student_by_intake_gender(1, 3, 2,programme.id).count if programme.course_type=="Diploma"}", "","#{@students.get_student_by_intake_gender(2, 3, 2,programme.id).count if programme.course_type=="Diploma"}", "","#{@students.get_student_by_intake_gender(1, 1, 2,programme.id).count if programme.course_type=="Diploma Lanjutan" ||programme.course_type=="Pos Basik"}", "","#{@students.get_student_by_intake_gender(2, 1, 2,programme.id).count if programme.course_type=="Diploma Lanjutan" || programme.course_type=="Pos Basik"}",{content: "#{@valid.count}", rowspan:2}]
          lines << [ "","","L","","#{Student.get_student_by_intake_gender(1, 1, 1,programme.id).count if programme.course_type=="Diploma"}","","#{@students.get_student_by_intake_gender(2, 1, 1,programme.id).count  if programme.course_type=="Diploma"}","","#{@students.get_student_by_intake_gender(1, 2, 1,programme.id).count if programme.course_type=="Diploma"}","","#{@students.get_student_by_intake_gender(2, 2, 1,programme.id).count if programme.course_type=="Diploma"}","","#{@students.get_student_by_intake_gender(1, 3, 1,programme.id).count if programme.course_type=="Diploma"}","","#{@students.get_student_by_intake_gender(2, 3, 1,programme.id).count if programme.course_type=="Diploma"}","","#{@students.get_student_by_intake_gender(1, 1, 1,programme.id).count if programme.course_type=="Diploma Lanjutan" ||programme.course_type=="Pos Basik"}","","#{@students.get_student_by_intake_gender(2, 1, 1,programme.id).count if programme.course_type=="Diploma Lanjutan" ||programme.course_type=="Pos Basik"}"]
       end
     end 
     header+lines
  end 
  
  def record1c
    table(line_item_rows1c, :column_widths =>  [23,60,45,50,45,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,55], :cell_style => { :size => 8,  :inline_format => :true}) do
      row(0..1).font_style = :bold
      row(0..3).background_color = 'FFE34D'
      row(0..1).align = :center
      column(2..21).align =:center
      self.row_colors = ["FEFEFE", "FFFFFF"]
      self.header = true
      self.width = 758
      header = true
    end
  end
  
  def line_item_rows1c
    counter = counter || 0
    header = @table_heading
    
    lines=[]
    @programmes_rev.each_with_index do |programme, counter|
      
        if programme.course_type=="Diploma"
         students_all_6intakes = Student.get_student_by_6intake(programme.id)
         @students_6intakes_ids = students_all_6intakes.map(&:id)
         @valid = Student.where('course_id=? AND race2 IS NOT NULL AND id IN(?)',programme.id, @students_6intakes_ids)
       else
         student_all_2intakes = Student.get_student_by_2intake(programme.id)
         @student_all_2intakes_ids = student_all_2intakes.map(&:id)
         @valid = Student.where('course_id=? AND race2 IS NOT NULL AND id IN(?)',programme.id, @students_2intakes_ids)
	 #@valid=@students
       end
       
       if counter > 9 && counter < 15
          lines<< [{content: "#{counter+=1}", rowspan:2}, {content: "#{programme.programme_list}", rowspan: 2},"","" ,"P","", "#{Student.get_student_by_intake_gender(1, 1, 2,programme.id).count if programme.course_type=="Diploma"}", "","#{@students.get_student_by_intake_gender(2, 1, 2,programme.id).count if programme.course_type=="Diploma"}", "","#{@students.get_student_by_intake_gender(1, 2, 2,programme.id).count if programme.course_type=="Diploma"}", "","#{@students.get_student_by_intake_gender(2, 2, 2,programme.id).count if programme.course_type=="Diploma"}", "","#{@students.get_student_by_intake_gender(1, 3, 2,programme.id).count if programme.course_type=="Diploma"}", "","#{@students.get_student_by_intake_gender(2, 3, 2,programme.id).count if programme.course_type=="Diploma"}", "","l#{@students.get_student_by_intake_gender(1, 1, 2,programme.id).count if programme.course_type=="Diploma Lanjutan" ||programme.course_type=="Pos Basik"}", "","k#{@students.get_student_by_intake_gender(2, 1, 2,programme.id).count if programme.course_type=="Diploma Lanjutan" || programme.course_type=="Pos Basik"}",{content: "#{@valid.count}  #{student_all_2intakes.count}", rowspan:2}]
          lines << [ "","","L","","#{Student.get_student_by_intake_gender(1, 1, 1,programme.id).count if programme.course_type=="Diploma"}","","#{@students.get_student_by_intake_gender(2, 1, 1,programme.id).count  if programme.course_type=="Diploma"}","","#{@students.get_student_by_intake_gender(1, 2, 1,programme.id).count if programme.course_type=="Diploma"}","","#{@students.get_student_by_intake_gender(2, 2, 1,programme.id).count if programme.course_type=="Diploma"}","","#{@students.get_student_by_intake_gender(1, 3, 1,programme.id).count if programme.course_type=="Diploma"}","","#{@students.get_student_by_intake_gender(2, 3, 1,programme.id).count if programme.course_type=="Diploma"}","","uu#{@students.get_student_by_intake_gender(1, 1, 1,programme.id).count if programme.course_type=="Diploma Lanjutan" ||programme.course_type=="Pos Basik"}","","h #{@students.get_student_by_intake_gender(2, 1, 1,programme.id).count if programme.course_type=="Diploma Lanjutan" ||programme.course_type=="Pos Basik"}"]
       end
     end 
     header+lines
  end 
  
  
  def record1d
    table(line_item_rows1d, :column_widths =>  [23,60,45,50,45,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,55], :cell_style => { :size => 8,  :inline_format => :true}) do
      row(0..1).font_style = :bold
      row(0..3).background_color = 'FFE34D'
      row(0..1).align = :center
      column(2..21).align =:center
      self.row_colors = ["FEFEFE", "FFFFFF"]
      self.header = true
      self.width = 758
      header = true
    end
  end
  
  def line_item_rows1d
    counter = counter || 0
    header = @table_heading
    
    lines=[]
    @programmes_rev.each_with_index do |programme, counter|
      
        if programme.course_type=="Diploma"
         students_all_6intakes = Student.get_student_by_6intake(programme.id)
         @students_6intakes_ids = students_all_6intakes.map(&:id)
         @valid = Student.where('course_id=? AND race2 IS NOT NULL AND id IN(?)',programme.id, @students_6intakes_ids)
       else
         student_all_2intakes = Student.get_student_by_2intake(programme.id)
         @student_all_2intakes_ids = student_all_2intakes.map(&:id)
         @valid = Student.where('course_id=? AND race2 IS NOT NULL AND id IN(?)',programme.id, @students_2intakes_ids)
       end
       
       if counter > 14 && counter < 20
         lines<< [{content: "#{counter+=1}", rowspan:2}, {content: "#{programme.programme_list}", rowspan: 2},"","" ,"P","", "#{Student.get_student_by_intake_gender(1, 1, 2,programme.id).count if programme.course_type=="Diploma"}", "","#{@students.get_student_by_intake_gender(2, 1, 2,programme.id).count if programme.course_type=="Diploma"}", "","#{@students.get_student_by_intake_gender(1, 2, 2,programme.id).count if programme.course_type=="Diploma"}", "","#{@students.get_student_by_intake_gender(2, 2, 2,programme.id).count if programme.course_type=="Diploma"}", "","#{@students.get_student_by_intake_gender(1, 3, 2,programme.id).count if programme.course_type=="Diploma"}", "","#{@students.get_student_by_intake_gender(2, 3, 2,programme.id).count if programme.course_type=="Diploma"}", "","#{@students.get_student_by_intake_gender(1, 1, 2,programme.id).count if programme.course_type=="Diploma Lanjutan" ||programme.course_type=="Pos Basik"}", "","#{@students.get_student_by_intake_gender(2, 1, 2,programme.id).count if programme.course_type=="Diploma Lanjutan" || programme.course_type=="Pos Basik"}",{content: "#{@valid.count}", rowspan:2}]
          lines << [ "","","L","","#{Student.get_student_by_intake_gender(1, 1, 1,programme.id).count if programme.course_type=="Diploma"}","","#{@students.get_student_by_intake_gender(2, 1, 1,programme.id).count  if programme.course_type=="Diploma"}","","#{@students.get_student_by_intake_gender(1, 2, 1,programme.id).count if programme.course_type=="Diploma"}","","#{@students.get_student_by_intake_gender(2, 2, 1,programme.id).count if programme.course_type=="Diploma"}","","#{@students.get_student_by_intake_gender(1, 3, 1,programme.id).count if programme.course_type=="Diploma"}","","#{@students.get_student_by_intake_gender(2, 3, 1,programme.id).count if programme.course_type=="Diploma"}","","#{@students.get_student_by_intake_gender(1, 1, 1,programme.id).count if programme.course_type=="Diploma Lanjutan" ||programme.course_type=="Pos Basik"}","","#{@students.get_student_by_intake_gender(2, 1, 1,programme.id).count if programme.course_type=="Diploma Lanjutan" ||programme.course_type=="Pos Basik"}"]
       end
     end 
     header+lines
  end 
  
  def cop
    move_down 5
    text "* P - Perempuan", :align => :left, :size => 9, :indent_paragraphs => 30
    text "* L - Lelaki", :align => :left, :size => 9, :indent_paragraphs => 30
  
    text "Disediakan oleh :                                                                                                                                                                                                         Disahkan oleh : ", :align => :left, :size => 9, :indent_paragraphs => 40
    move_down 15
    text "---------------------------                                                                                                                                                                                                     -----------------------------", :align => :left, :size => 9, :indent_paragraphs => 30
    text "Nama :                                                                                                                                                                                                                             Pengarah", :align => :left, :size => 9, :indent_paragraphs => 30
    text "Jawatan", :align => :left, :size => 9, :indent_paragraphs => 30
  
    text "Catatan : ", :align => :left, :size => 9, :indent_paragraphs => 30
    text "* Laporan setiap 6 bulan pada 15 Februari & 15 Ogos", :align => :left, :size => 9, :indent_paragraphs => 30
  end

end