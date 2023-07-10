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


  def current_fiscal_year
    # ���݂̓��t���擾
    current_date = Date.today

    # �N�x�̊J�n����ݒ�
    fiscal_year_start = Date.new(current_date.year, 4, 1)

    # ���O�C���������t���N�x�J�n�����O�̏ꍇ�A�O�̔N�x���擾
    if current_date < fiscal_year_start
      fiscal_year = current_date.year - 1
    else
      fiscal_year = current_date.year
    end

    fiscal_year
  end
end
