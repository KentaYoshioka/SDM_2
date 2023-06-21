class AssignShiftController < ApplicationController
  def index
  @course = Course.find(params[:course_id])
  end

  def search
    number = params[:number]
    name = params[:name]
    @search_result = TeachingAssistant.where("name LIKE ? AND number LIKE ?", "%#{name}%","%#{number}%")
    render json: @search_result
  end
end
