class WorkHour < ApplicationRecord
  belongs_to :assignment


  def self.create_work_hour(date, start, finish, course_id, work_time)
    if start < finish
      start_time = DateTime.new(date.year, date.month, date.day, start.hour, start.min)
      end_time = DateTime.new(date.year, date.month, date.day, finish.hour, finish.min)
      if work_time  =~ /^[0-9]+$/
        if work_time.to_i <= (finish - start) / 60
          assignment = Assignment.find_by(course_id: course_id, teaching_assistant_id: TeachingAssistant.find_by(description: "dammy").id)
          existing_record = WorkHour.find_by(start_time: start_time, end_time: end_time, assignment_id: assignment.id, work_time: work_time.to_i)

          if existing_record.nil?
            WorkHour.create(start_time: start_time, end_time: end_time, assignment_id: assignment.id, work_time: work_time.to_i)
            return true
          else
            return false
          end
        end
      end
    end
  end
end

