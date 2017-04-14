class Employgrade < ActiveRecord::Base
  before_destroy :valid_for_removal
  
  has_many :staffs, :class_name => 'Staff', :foreign_key => 'staffgrade_id', :dependent => :nullify
  has_many :staffgrades, :class_name => 'Position', :foreign_key => 'staffgrade_id'
  has_one :rank
  
  has_many :staffemploygrades
  has_many :staffemployschemes, :through => :staffemploygrades
  
  validates_uniqueness_of :name, :scope => :group_id
  validates_presence_of :name
  
  def grade_group
    (DropDown::GROUP.find_all{|disp, value| value == group_id}).map {|disp, value| disp}[0]
  end
  
  def name_and_group
    "#{name}  (#{grade_group})"
  end
  
  def gred_no
    #"#{name[1,2]}"
    #no_only=name.gsub(/[^0-9]/, '')
    #no_only.to_i
    no_only=name.gsub(/[^\/, ^0-9]/, '')
    if no_only.include?("/")
      no=no_only.split("/")[0]
    else
      no=no_only
    end
    no.to_i
  end
  
  def gred_str
    name.gsub(/[0-9]/, '')
  end
  
  #hide delete icon in index
  def valid_for_removal
    stf=staffs.count
    stg=staffgrades.count
    #seg=staffemploygrades.count
    if stf > 0 || stg > 0 || rank # || seg.count > 0
      return false
    else
      return true
    end
  end
  
  # NOTE - 4 methods below - use in Emplogrades & Staffs Index pgs (AMSAS) -13-14Jan2017
  
  def self.grade_legend
    #1) NOTE: Legend/formula - ...Home/Desktop/APMM Kuantan ICMS/[0] Format, Ref/Gred.pdf
    maritim = [     24, 22, 20,  18,     16,  14, 13, 12, 10,   8,  [5,6],   nil,  4,    2,    1, nil]             
    non_maritim=[54, 52, 48, "46A", 44,  41, 41, 38, 36,  32,    29,   27,  22,  20,  17, 11]
    
    #2) combine above 2 arrays to become : 
    #{0=>[24, 54], 1=>[22, 52], 2=>[20, 48], 3=>[18, "46A"], 4=>[16, 44], 5=>[14, 41], 6=>[13, 41], 7=>[12, 38], 8=>[10, 36], 9=>[8, 32], 10=>[[5, 6], 29], 11=>[nil, 27], 12=>[4, 22], 13=>[2, 20], 14=>[1, 17]} 
    combine=Hash.new
    0.upto(maritim.size-1).each{|cnt| combine[cnt]=[maritim[cnt], non_maritim[cnt]]}
    
    combine
  end
  
  #to cater level 4 & level 5 (maritime : 13 & 14 - matching civil : 41)
  def self.grade41_count
    where.not('name ILIKE(?) or name ILIKE(?)', "x%", "X%").where('name ilike(?)', "%41").count
  end

  #Employgrade Index : shall SORT list according comparison between maritime & civil grades (LEVEL / 'tangga gaji' applied)
  def self.sorted_grades(grade_list)
    #3) retrieve maritime & non maritime grades records separately
    m_grds=grade_list.where('name ILIKE(?) or name ILIKE(?)', "xa%", "XA%")
    nm_grds=grade_list.where.not('name ILIKE(?) or name ILIKE(?)', "x%", "X%")
    
    #4) Combine above maritime & non_maritime (SORT by combine_grades)
    #loop through grade_legend, check for each key - if 1st value exist in m_grds & 2nd value exist in nm_grds, assign into ARRAY (@egrades)
    #note, 41 values for non_maritim exist twice
    cnt=0
    egrades=[]
    Employgrade.grade_legend.each do |k, v|
        for m_grd in m_grds.sort_by(&:name)
            be4slash, afterslash=m_grd.name.split("/")
            x=be4slash.gsub(/[^0-9]/, "").to_i
            if x==v[0]   
                egrades << m_grd
            end
            if k==10
                if v[0].include?(x)
                    egrades << m_grd
                end
            end
        end
        for nm_grd in nm_grds.sort_by(&:name)
            be4slash, afterslash=nm_grd.name.split("/")
            y=be4slash.gsub(/[^0-9]/, "").to_i
            if y==v[1] && (y !=41 || (y==41 && cnt < Employgrade.grade41_count))    
                egrades << nm_grd
                cnt+=1 if v[1]==41
            end
        end
    end
    egrades
  end

  #Staffs Index : shall SORT staff list based on combine maritim & non_maritime employgrades
  def self.sorted_staff_bygrade(staff_list)
    cnt=0
    staffs_w_grades=[]
    Employgrade.grade_legend.each do |k, v|
      for staff in staff_list.sort_by{|x|x.staffgrade.name}
	    be4slash, afterslash=staff.staffgrade.name.split("/")
            x=be4slash.gsub(/[^0-9]/, "").to_i
            first_char=be4slash.lstrip[0,1]
            if first_char.downcase=='x'            #maritime grade should start with letter 'x' of 'X'
              if x==v[0]
	        staffs_w_grades << staff
	      end
	      if k==10
                  if v[0].include?(x)
                      staffs_w_grades << staff
                  end
              end
	    else
	      if x==v[1]                                    #should list all staff with same employgrade
                  staffs_w_grades << staff
                  cnt+=1 if v[1]==41
              end
	    end
      end
    end
    staffs_w_grades
  end
  
  def self.sorted_postinfo_bygrade(postinfo_list)
    cnt=0
    staffs_w_grades=[]
    Employgrade.grade_legend.each do |k, v|
      for staff in postinfo_list.sort_by{|x|x.employgrade.name}#{|x|x.staffgrade.name}   #x.employgrade.gred_no
	    be4slash, afterslash=staff.employgrade.name.split("/") #staff.staffgrade.name.split("/")
            x=be4slash.gsub(/[^0-9]/, "").to_i
            first_char=be4slash.lstrip[0,1]
            if first_char.downcase=='x'            #maritime grade should start with letter 'x' of 'X'
              if x==v[0]
	        staffs_w_grades << staff
	      end
	      if k==10
                  if v[0].include?(x)
                      staffs_w_grades << staff
                  end
              end
	    else
	      if x==v[1]                                    #should list all staff with same employgrade
                  staffs_w_grades << staff
                  cnt+=1 if v[1]==41
              end
	    end
      end
    end
    staffs_w_grades
  end
 
end

# == Schema Information
#
# Table name: employgrades
#
#  created_at :datetime
#  group_id   :integer
#  id         :integer          not null, primary key
#  name       :string(255)
#  updated_at :datetime
#
