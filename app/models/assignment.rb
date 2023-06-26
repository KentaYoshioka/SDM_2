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
          puts ta_id
          puts "すでに追加されています"
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

end
