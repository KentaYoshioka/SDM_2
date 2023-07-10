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
    # 現在の日付を取得
    current_date = Date.today

    # 年度の開始日を設定
    fiscal_year_start = Date.new(current_date.year, 4, 1)

    # ログインした日付が年度開始日より前の場合、前の年度を取得
    if current_date < fiscal_year_start
      fiscal_year = current_date.year - 1
    else
      fiscal_year = current_date.year
    end

    fiscal_year
  end
end
