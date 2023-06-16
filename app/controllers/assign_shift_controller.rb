class AssignShiftController < ApplicationController
  def index
  @course = Course.find(params[:course_id])
  #@teaching_assistants = Teaching_assistants
  end
  def add_TA_text
    respond_to do |format|
      format.js
    end
  end
end
