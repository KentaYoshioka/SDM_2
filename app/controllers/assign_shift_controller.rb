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
    selected_TA.each do |ta_id|
      Assignment.create(course_id: params[:course_id], teaching_assistant_id: ta_id)
    end
    redirect_to request.referrer
  end

  def delete_TA
    selected_TA = params[:selected_items]
    selected_TA.each do |ta_id|
      assignment = Assignment.find_by(teaching_assistant_id: ta_id)
      assignment.destroy if assignment
    end
    redirect_to request.referrer
  end

  def add_work_time
    date = Date.parse(params[:date])
    start = Time.parse(params[:start])
    finish = Time.parse(params[:finish])
    start_time = DateTime.new(date.year, date.month, date.day, start.hour, start.min)
    end_time = DateTime.new(date.year, date.month, date.day, finish.hour, finish.min)
    work_time = params[:work_time].to_i
    assignment = Assignment.find_by(course_id: params[:course_id],teaching_assistant_id: TeachingAssistant.find_by(description: "dammy").id)
    WorkHour.create(start_time: start_time, end_time: end_time, assignment_id: assignment.id, work_time: work_time)
    redirect_to request.referrer
  end

  def delete_work_time
    selected_work_time = params[:selected_items]
    selected_work_time.each do |work_time_id|
      work=WorkHour.find_by(id: work_time_id.to_i)
      work.destroy
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
