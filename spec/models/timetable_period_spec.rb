require 'spec_helper'

describe TimetablePeriod do

  before do
    @admin_user=FactoryGirl.create(:admin_user)
    sign_in(@admin_user)
    @timetable=FactoryGirl.create(:timetable)
    @timetable_period = FactoryGirl.create(:timetable_period, timetable: @timetable, sequence: 1, seq: 1)
  end
      
  subject { @timetable_period }
  
  it { should respond_to(:timetable_id) }
  it { should respond_to(:sequence) }
  it { should respond_to(:day_name) }
  it { should respond_to(:start_at) }
  it { should respond_to(:end_at) }
  it { should respond_to(:is_break) }
  
  it { should be_valid }
  
# NOTE - this validation not exist?
#   describe "when timetable is not present" do
#     before { @timetable_period.timetable_id = nil }
#     it { should_not be_valid }
#   end
  
  describe "when sequence, seq is not unique within same timetable" do
    before do
      @timetable_period2=FactoryGirl.build(:timetable_period, timetable: @timetable, sequence: 1, seq: 1)
    end
    subject { @timetable_period2 }
    it { should_not be_valid }
  end
  
end