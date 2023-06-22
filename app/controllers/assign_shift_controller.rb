class AssignShiftController < ApplicationController
  def index
  @course = Course.find(params[:course_id])
  @assignments = Assignment.where(course_id: params[:course_id])
  @assigned_teaching_assistant = TeachingAssistant.where(id: @assignments.pluck(:teaching_assistant_id))
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
end
