class AssignShiftController < ApplicationController
include ApplicationHelper
  def index
    unless TeachingAssistant.find_by(description: "dammy")
      TeachingAssistant.create(description: "dammy")
    end
    create_initial_work_hour unless Assignment.exists?(course_id: params[:course_id], teaching_assistant_id: TeachingAssistant.find_by(description: "dammy").id)
    @course = Course.find(params[:course_id])
    @assignments = Assignment.where(course_id: params[:course_id]).where.not(teaching_assistant_id: TeachingAssistant.find_by(description: "dammy").id)
    @assigned_teaching_assistant = TeachingAssistant.where(id: @assignments.pluck(:teaching_assistant_id))
    @work_hour = WorkHour.where(assignment_id: Assignment.find_by(course_id: params[:course_id]))
    @complete_assignment = WorkHour.joins(assignment: :teaching_assistant).where.not(assignments: { id: nil }).where.not(assignments: { teaching_assistant_id: TeachingAssistant.find_by(description: "dammy").id }).where(assignments:{course_id:params[:course_id]})
  end

  def search
    number = params[:number]
    name = params[:name]
    fiscal_year = current_fiscal_year
    @search_result = TeachingAssistant.where(year: fiscal_year).where("name LIKE ? AND number LIKE ?", "%#{name}%","%#{number}%")

    if @search_result.empty?
      puts "検索結果がありません．"
      render json: { error: "該当する学生が存在しません．" }, status: :unprocessable_entity
    else
      render json: @search_result
    end
  end



  def add_TA
    selected_TA = params[:selected_items]
    puts selected_TA
    if selected_TA.nil?
      render json: { error: '対象者が選択されていません．' }, status: :unprocessable_entity
    else
      Assignment.add_ta(params[:course_id], selected_TA)
      flash[:success]="TAが割り当てられました"
      redirect_to request.referrer
    end
  end


  def delete_TA
    selected_ta = params[:selected_items]
    if selected_ta.nil?
      render json: { error: '削除対象者が選択されていません．' }, status: :unprocessable_entity
    else
      Assignment.delete_ta(selected_ta)
      flash[:success]="TAが削除されました"
      redirect_to request.referrer
    end
  end

  def add_work_time
    start_time = Time.parse(params[:start])
    finish_time = Time.parse(params[:finish])
    work_time = params[:work_time].to_i
    if params[:work_time] == "0"
      flash[:duplication]="入力値に異常があります"
      redirect_to request.referrer
    elsif params[:start] >= params[:finish]
      flash[:duplication]="入力値に異常があります"
      redirect_to request.referrer
    elsif finish_time - start_time < work_time.minutes
      flash[:duplication]="入力値に異常があります"
      redirect_to request.referrer
    elsif params[:date].present? && params[:start].present? && params[:finish].present? && params[:work_time].present?
      date = Date.parse(params[:date])
      start = Time.parse(params[:start])
      finish = Time.parse(params[:finish])
      work_time = params[:work_time]
      if WorkHour.create_work_hour(date, start, finish, params[:course_id], work_time)
        flash[:success]="勤務時間が割り当てられました"
        redirect_to request.referrer
      end
    else
      flash[:duplication]="入力値に異常があります"
      redirect_to request.referrer
    end
  end


  def delete_work_time
    if params[:selected_items].present?
      selected_work_time = params[:selected_items]
      selected_work_time.each do |work_time_id|
        work=WorkHour.find_by(id: work_time_id.to_i)
        work.destroy
      end
      flash[:success]="勤務時間が削除されました．"
      redirect_to request.referrer
    else
      render json: { error: '削除する勤務時間が選択されていません．' }, status: :unprocessable_entity
    end

  end

  def add_assignment
    teaching_assistant = params[:teaching_assistant_id]
    work_hour_id = params[:work_hour_id].to_i
    puts params[:course_id]
    if Assignment.duplication?(teaching_assistant,work_hour_id)
      flash[:duplication] = "勤務時間が重複しています"
      redirect_to request.referrer and return
    end
    assignment = Assignment.find_by(course_id: params[:course_id], teaching_assistant_id: teaching_assistant)
    work_hour = WorkHour.find_by(id: work_hour_id)
    WorkHour.create(start_time: work_hour.start_time, end_time: work_hour.end_time, assignment_id: assignment.id,work_time: work_hour.work_time)
    flash[:success]="シフトが割り当てられました"
    redirect_to request.referrer and return
  end

  def delete_assgnment
    selected_assign = params[:selected_items]
    if selected_assign.nil?
      render json: { error: '削除するシフトが選択されていません' }, status: :unprocessable_entity
    else
      selected_assign.each do |work_time_id|
        work=WorkHour.find_by(id: work_time_id.to_i)
        work.destroy
      end
      flash[:success]="シフトが削除されました"
      redirect_to request.referrer
    end
  end


  private

  def create_initial_work_hour
    Assignment.create(course_id: params[:course_id],teaching_assistant_id: TeachingAssistant.find_by(description: "dammy").id)
  end
end
