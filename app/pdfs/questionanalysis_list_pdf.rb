class Questionanalysis_listPdf < Prawn::Document
  def initialize(examanalysis, view, college)
    super({top_margin: 125, left_margin: 20, bottom_margin: 50, page_size: 'A4', page_layout: :landscape })
    @examanalysis = examanalysis
    @view = view
    @college=college
    font "Helvetica"
    record
    page_count.times do |i|
      go_to_page(i+1)
      logo_header
      footer
    end
    table_ending
  end
  
  def logo_header
    bounding_box([30,520], :width => 400, :height => 70) do |y2|
      image "#{Rails.root}/app/assets/images/logo_kerajaan.png", :scale => 0.70
    end
    bounding_box([700,520], :width => 400, :height => 70) do |y2|
      image "#{Rails.root}/app/assets/images/amsas_logo_small.png", :scale => 0.85
    end
    bounding_box([140, 510], :width => 500, :height => 60) do |y2|
      text "PPL APMM", :align => :center, :size => 10, :style => :bold
      text "NO. DOKUMEN: BK-KKM-06-01",  :align => :center, :size => 10, :style => :bold
      move_down 5
      text "BORANG ANALISA KEPUTUSAN PEPERIKSAAN", :align => :center, :size => 10, :style => :bold
    end
    bounding_box([20, 450], :width => 500, :height => 30) do |y2|
      text "KURSUS : #{@examanalysis.exampaper.subject.root.programme_list.upcase} ", :size => 9
      move_down 3
      text "KELAS : #{@examanalysis.exampaper.subject.subject_list.upcase} (#{(I18n.t 'training.programme.module').upcase} : #{@examanalysis.exampaper.subject.parent.name})", :size => 9
    end  
    bounding_box([345, 450], :width => 500, :height => 30) do |y2|
      text "PEPERIKSAAN : #{@examanalysis.exampaper.render_full_name.upcase} ",  :size => 9
      move_down 3
      text "TARIKH PEPERIKSAAN : #{@examanalysis.exampaper.exam_on.strftime("%d-%m-%Y")}",  :size => 9
    end 
  end
  
  def record
    a=[]
    0.upto(37).each do |cnt|
      a << 15 #12#11#10# 17
    end
    student_ids=@examanalysis.exampaper.exammarks.pluck(:student_id)
    last_row=Student.where(id: student_ids).count+3+1
    mcq_count= @examanalysis.exampaper.examquestions.where(questiontype: 'MCQ').count
    othertype_count=@examanalysis.exampaper.examquestions.where.not(questiontype: 'MCQ').count
    table(line_item_rows, :column_widths => [20, 60, 110]+a+[35], :cell_style => { :size => 7,  :inline_format => :true, :padding => [0,0,3,1]}, :header => 2) do
      row(0..2).align = :center
      row(0..2).font_style = :bold
      row(0..2).background_color = 'FFE34D'
      row(3..last_row-2).columns(3+mcq_count+othertype_count..40).background_color='F1F1F1'
      row(last_row-1).column(0).borders=[:left, :bottom]
      row(last_row-1).column(1).borders=[:right, :bottom, :top]
      row(last_row).borders=[]  
      column(0).align=:center
      column(3..41).align=:center
      self.width=795 #737#778#786
    end
  end
  
  def line_item_rows
    ####
    paper=@examanalysis.exampaper
    @examquestions_by_type = paper.examquestions.group_by{|x|x.questiontype}.sort
    if paper.sequ!= nil 
      sequ = paper.sequ.split(",")
      seq_questionid = [] 
      hash_seqid = Hash.new
      tosort_seqid = Hash.new
      select_questionid = [] 
      count = 0
      listed_questions=[]
      
      #reference - /exams/_tab_question_details.html.haml
      #START-ASSIGN QUESTIONS WITH SEQUENCE INTO HASH & QUESTIONS WITHOUT SEQUENCE INTO ARRAY ACCORDINGLY
      @examquestions_by_type.each do |qtype,examquestions|
        for examquestion in examquestions 
          if sequ[count] != "Select"
            hash_seqid = {sequ[count] => examquestion.id}
            #FORMAT:grades = { "Jane Doe" => 10, "Jim Doe" => 6 }
            tosort_seqid = tosort_seqid.merge(hash_seqid)
          else 
            select_questionid << examquestion.id
	  end
	  count+=1 
	end
      end
      #for question with sequence-SORT by its' sequence
      tosort_seqid.sort_by{|k,v|k.to_i}.each do |x,y|
        seq_questionid << y
      end
      #for question with sequence-SORT by its' sequence
      #END-ASSIGN QUESTIONS WITH SEQUENCE INTO HASH & QUESTIONS WITHOUT SEQUENCE INTO ARRAY ACCORDINGLY
            
      #START-QUESTIONS WITH & WITHOUT SEQUENCE NO ACCORDINGLY
      #START-WORKABLE ONE-FOR EXAMQUESTION-WITH SEQUENCE NO
      current_qtype = Examquestion.find(seq_questionid[0]).questiontype
      0.upto(tosort_seqid.count-1) do |count|
        current_question = Examquestion.find(seq_questionid[count])
        listed_questions << current_question
      end
      #END-WORKABLE ONE-FOR EXAMQUESTION-WITH SEQUENCE NO	
      #START-WORKABLE ONE-FOR EXAMQUESTION-WITHOUT SEQUENCE NO
      0.upto(sequ.count-tosort_seqid.count-1) do |counter|
        current_question = Examquestion.find(select_questionid[counter])       
        listed_questions << current_question     
      end
    else
      #else for if @exam.sequ!= nil (SEQUENCE NEVER SET YET..first time data entry only:column sequence in exam table BLANK)
      @examquestions_by_type.each do |qtype,examquestions|
        examquestions.each_with_index do |examquestion, index|
          current_question=examquestion
          listed_questions << current_question
	end
      end
    end
    exammarks=paper.exammarks
    students=Student.where(id: exammarks.pluck(:student_id))
    mcq_count= paper.examquestions.where(questiontype: 'MCQ').count
    ####
    
    fullmarks_arr=[]
    remaining_columns=[]
    
    listed_questions.each_with_index do |question, nos|
      fullmarks_arr << question.marks.to_i
    end
    bal_question=38-listed_questions.count
    0.upto(bal_question-1).each do |no|
      fullmarks_arr << "-"
      remaining_columns << ""
    end

    counter=counter || 0
    
    header = [[{content: "NO SOALAN", colspan: 3},"1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31", "32", "33", "34", "35", "36", "37", "38", "JUMLAH MARKAH" ], [{content: "MARKAH PENUH", colspan: 3}]+fullmarks_arr+[paper.total_marks], ['SIRI', 'NO KP', 'NAMA', {content: "", colspan: 38}, ""]]
    body=[]
    
    for student in students.sort_by{|x|[x.id, x.name]} 
        acc_marks=0
        total_mcq=exammarks.where(student_id: student.id).first.total_mcq
	question_fields=[{content: "#{total_mcq.to_i}", colspan: mcq_count}]
	listed_questions.each_with_index do |question, nos|
            if nos > mcq_count-1
                indv_marks=exammarks.where(student_id: student.id).first.marks[nos-(mcq_count)].student_mark
                acc_marks+=indv_marks
	    end
	    if question.questiontype!='MCQ'
                question_fields << indv_marks.to_i
            end
	end
	total_scores=total_mcq+acc_marks
        body << ["#{counter+=1}", student.icno, student.name]+question_fields+remaining_columns+[total_scores]
    end
    body << ["", {content: "NAMA PEMERIKSA", colspan: 41}]
    #DO NOT remove this line
    body << ["", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""]
    
    header+body
  end
  
  def table_ending
    bounding_box([0, 5], :width => 795, :height => 70) do |y2|
      data=[["#{I18n.t('instructor_appraisal.prepared').upcase}: BKKM","#{I18n.t('exam.evaluate_course.date_updated')} : #{@examanalysis.updated_at.try(:strftime, '%d-%m-%Y')} "]]
      table(data, :column_widths => [500, 295], :cell_style => {:size=>9, :borders => [:left, :right, :top, :bottom], :padding => [0,5,0,5]}) do
        column(0..1).font_style = :bold
	column(0).borders=[:top, :bottom, :left]
	column(1).borders=[:top, :right, :bottom]
	column(1).align =:right
	row(0).height=12
      end
    end
  end
  
  def footer
    draw_text "#{page_number} / #{page_count}",  :size => 8, :at => [780,-15]
  end

end