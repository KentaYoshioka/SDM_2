class Assignment < ApplicationRecord
  belongs_to :course
  belongs_to :teaching_assistant
  has_many :work_hour, dependent: :destroy


  def self.add_ta(course_id, ta_ids)
    if ta_ids.nil?
      puts "対象者が選択されていません．"
    else
      ta_ids.each do |ta_id|
        existing_record = find_by(course_id: course_id, teaching_assistant_id: ta_id)
        if existing_record
          return "すでに追加されています"
        else
          create(course_id: course_id, teaching_assistant_id: ta_id)
        end
      end
    end
  end

  def self.delete_ta(selected_ta)
    if selected_ta.nil?
      puts "削除対象者が選択されていません．"
    else
      selected_ta.each do |ta_id|
        assignment = find_by(teaching_assistant_id: ta_id)
        assignment.destroy if assignment
      end
    end
  end

  def self.duplication?(teaching_assistant_id, work_hour_id)
    workhour = WorkHour.find_by(id: work_hour_id)
    results = WorkHour.where("start_time <= ? AND end_time >= ?", workhour.end_time, workhour.start_time)
    results.each do |result|
      assign = Assignment.find_by(id: result.assignment_id)
      if assign.teaching_assistant_id == teaching_assistant_id.to_i
        return true
      end
    end
    return false
  end


end
