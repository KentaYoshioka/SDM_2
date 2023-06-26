class AssignShiftController < ApplicationController
  def index
    unless TeachingAssistant.find_by(description: "dammy")
      TeachingAssistant.create(description: "dammy")
    end
    create_initial_work_hour unless Assignment.exists?(course_id: params[:course_id], teaching_assistant_id: TeachingAssistant.find_by(description: "dammy").id)
    @course = Course.find(params[:course_id])
    @assignments = Assignment.where(course_id: params[:course_id]).where.not(teaching_assistant_id: TeachingAssistant.find_by(description: "dammy").id)
    @assigned_teaching_assistant = TeachingAssistant.where(id: @assignments.pluck(:teaching_assistant_id))
    @work_hour = WorkHour.where(assignment_id: Assignment.find_by(course_id: params[:course_id]))
    @complete_assignment = WorkHour.joins(assignment: :teaching_assistant).where.not(assignments: { id: nil }).where.not(assignments: { teaching_assistant_id: TeachingAssistant.find_by(description: "dammy").id })
  end

  def search
    number = params[:number]
    name = params[:name]
    @search_result = TeachingAssistant.where("name LIKE ? AND number LIKE ?", "%#{name}%","%#{number}%")
    render json: @search_result
  end


  def add_TA
    selected_TA = params[:selected_options]
    Assignment.add_ta(params[:course_id], selected_TA)
    redirect_to request.referrer
  end

  def delete_TA
    selected_ta = params[:selected_items]
    Assignment.delete_ta(selected_ta)
    redirect_to request.referrer
  end

  def add_work_time
    if params[:date].present? && params[:start].present? && params[:finish].present? && params[:work_time].present?
      date = Date.parse(params[:date])
      start = Time.parse(params[:start])
      finish = Time.parse(params[:finish])
      work_time = params[:work_time].to_i
      if WorkHour.create_work_hour(date, start, finish, params[:course_id], work_time)
        redirect_to request.referrer
      end
    else
      puts "日時，実働時間を選択してください．"
    end
  end


  def delete_work_time
    if params[:selected_items].present?
      selected_work_time = params[:selected_items]
      selected_work_time.each do |work_time_id|
        work=WorkHour.find_by(id: work_time_id.to_i)
        work.destroy
      end
    else
      puts "勤務時間削除の対象が選択されていません．"

    end
    redirect_to request.referrer
  end

  def add_assignment
    teaching_assistant = params[:teaching_assistant_id]
    work_hour_id = params[:work_hour_id].to_i
    assignment = Assignment.find_by(course_id: params[:course_id], teaching_assistant_id: teaching_assistant)
    work_hour = WorkHour.find_by(id: work_hour_id)
    WorkHour.create(start_time: work_hour.start_time, end_time: work_hour.end_time, assignment_id: assignment.id,work_time: work_hour.work_time)
    redirect_to request.referrer
  end

  def delete_assgnment
    selected_assign = params[:selected_items]
    selected_assign.each do |work_time_id|
      work=WorkHour.find_by(id: work_time_id.to_i)
      work.destroy
    end
    redirect_to request.referrer
  end


  private

  def create_initial_work_hour
    Assignment.create(course_id: params[:course_id],teaching_assistant_id: TeachingAssistant.find_by(description: "dammy").id)
  end
end
