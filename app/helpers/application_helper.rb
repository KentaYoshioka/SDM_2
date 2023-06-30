module ApplicationHelper
  def calc_time_allcation(course)
    work_hours = WorkHour.joins(assignment: :teaching_assistant).where(assignments: { course_id: course.id }).where.not(teaching_assistants: { name: "dammy" })
    time_allocation = 0
    work_time_record = []

    work_hours.each do |work_hour|
      
      minutes = work_hour.work_time
      assignments_count = Assignment.where(id: work_hour.assignment_id).count
      each_time_allocation = minutes * assignments_count
      time_allocation += each_time_allocation

    end



      time_allocation
  end
end
