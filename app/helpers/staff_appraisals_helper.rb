module StaffAppraisalsHelper
  def set_approver1(curr_user)
    #refer Leaveforstaff if required
    #---------------------------
    #temp: remove 'Ketua Teras' from Task & Responsibilities if not required+Ketua Teras part(below)
    appraised = curr_user.userable
    applicant_unit = appraised.positions.first.unit
    applicant_grade = appraised.staffgrade.name[-2,2]
    unit_members=Position.joins(:staff).where('unit=? and positions.name!=?', applicant_unit, "ICMS Vendor Admin").order(ancestry_depth: :asc)

    if Programme.roots.map(&:name).include?(applicant_unit)
      #Academician--start---
      highest_rank = unit_members.sort_by{|x|x.staffgrade.name[-2,2]}.last
      highest_grade = highest_rank.staffgrade.name[-2,2]
      maintasks = appraised.positions.first.tasks_main
      if maintasks.include?("Ketua Program")
        approver1 =  Position.where('name=?', "Timbalan Pengarah Akademik (Pengajar)").first.staff_id
      #elsif maintasks.include?("Ketua Teras")
	#if highest_grade > applicant_grade #kp exist
	  #approver1 = highest_rank.staff_id
	#else #kp not exist - die ketua prog (tanggung tugas)
	  #approver1 =  Position.find(:first, :conditions => ['name=?', "Timbalan Pengarah Akademik (Pengajar)"]).staff_id
	#end
      else #pengajar
        app=0
	#kt_id=[]
	unit_members.each do |u|
          #if u.tasks_main.include?("Ketua Teras")
	    #app+=1
	    #kt_id<< u.id
	  #elsif u.tasks_main.include?("Ketua Program")
	  if u.tasks_main.include?("Ketua Program")
	    app+=1
	  end
	end
	if app==1
	  approver1 = highest_rank.staff_id
	#elsif app==2
	  #approver1 = Position.find(kt_id[0]).staff_id
	end
      end
      #Academician--end---

    elsif ["Teknologi Maklumat", "Pusat Sumber", "Perpustakaan", "Kewangan & Akaun", "Sumber Manusia"].include?(applicant_unit) || applicant_unit.include?("logistik") || applicant_unit.include?("perkhidmatan")
      #Administration--start--
      highest_rank = unit_members.sort_by{|x|x.staffgrade.name[-2,2]}.last
      highest_grade = highest_rank.staffgrade.name[-2,2]
      if highest_grade > applicant_grade #staffs
        approver1 = highest_rank.staff_id
      elsif highest_grade == applicant_grade #Ketua Unit
        approver1 =  appraised.positions.first.parent.staff_id
      end
      #Administration--end---

    elsif ["Kejuruteraan", "Pentadbiran Am", "Perhotelan", "Aset & Stor"].include?(applicant_unit)
      approver1 = Position.where('unit=?', "Pentadbiran").staff_id

    elsif applicant_unit == "Pengurusan Tertinggi"
      if appraised.positions.first.name=="Pengarah"
        approver1=nil
      else
        approver1=Position.where('name=?', "Pengarah").staff_id
      end

    else
      #Administration2--start---
      if appraised.positions.first.parent.staff.id == []
        approver1 = nil
      else
        approver1 = appraised.positions.first.parent.staff.id   #if pentadbiran OK - applicant.position.unit=="Pentadbiran"
      end
      #Administration2--end---
      #-----------------------------------
    end

  end
end
