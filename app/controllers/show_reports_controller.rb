class ShowReportsController < ApplicationController
  require 'rubyXL'
  require 'rubyXL/convenience_methods'

  def index
  end

  def search
    if params[:word_number].present?
      @word = params[:word_number]
      @teachingassistants = TeachingAssistant.where("number LIKE ?", "%#{@word}%")
    elsif params[:word_name].present?
      @word = params[:word_name]
      @teachingassistants = TeachingAssistant.where("name LIKE ?", "%#{@word}%")
    else
      @teachingassistants = TeachingAssistant.all
    end

    render 'show_reports/index'
  end
  
  def search_month(month,day,work_info,worksheet)
    case month
    when 4
      search_day(day,14,0,work_info,worksheet)
    when 5
      search_day(day,14,7,work_info,worksheet)
    when 6
      search_day(day,14,14,work_info,worksheet)
    when 7
      search_day(day,14,21,work_info,worksheet)
    when 8
      search_day(day,30,0,work_info,worksheet)
    when 9
      search_day(day,30,7,work_info,worksheet)
    when 10
      search_day(day,30,14,work_info,worksheet)
    when 11
      search_day(day,30,21,work_info,worksheet)
    when 12
      search_day(day,46,0,work_info,worksheet)
    when 1
      search_day(day,46,7,work_info,worksheet)
    when 2
      search_day(day,46,14,work_info,worksheet)
    when 3
      search_day(day,46,21,work_info,worksheet)
    end
  end
  def search_day(day,row,line,work_info,worksheet)
    for j in 0..4 do
      for i in 0..6 do
        if worksheet[row+2*j][line+i]&.value.present?
          logger.debug(worksheet[row+2*j][line+i].value.inspect)
          if worksheet[row+2*j][line+i].value == day
            worksheet.add_cell(row+2*j+1,line+i,work_info.work_time)
            worksheet[row+2*j+1][line+i].change_font_size(7)
          end
        end
      end
    end
  end
  def write_excel1
    @id = params[:student_id]
    teaching_assistant = TeachingAssistant.find_by("number LIKE ?", "#{@id}")
    shifts = Assignment.where("teaching_assistant_id LIKE ?", "#{teaching_assistant.id}")
    workbook = RubyXL::Parser.parse('app/assets/excel/report_type1.xlsx')
    worksheet = workbook[1]
    worksheet.add_cell(18, 2, teaching_assistant.name.to_s.force_encoding("UTF-8"))
    worksheet.add_cell(18, 21, teaching_assistant.number.to_s.force_encoding("UTF-8"))
    worksheet.add_cell(20, 15, teaching_assistant.grade.to_s.force_encoding("UTF-8"))
    count = 0
    shifts.each_with_index do |shift, index|
      course_info = Course.find_by("id LIKE ?", "#{shift.course_id}")
      work_infos = WorkHour.where("assignment_id LIKE ?", "#{shift.id}")
    
      work_infos.each_with_index do |work_info, index2|
        worksheet.add_cell(36 + count, 1, course_info.number.to_s.force_encoding("UTF-8"))
        worksheet.add_cell(36 + count, 3, course_info.name.to_s.force_encoding("UTF-8"))
        worksheet.add_cell(36 + count, 8, course_info.term)
        worksheet.add_cell(36 + count, 11, work_info.start_time.strftime("%-H時%-M分%-S秒").to_s.force_encoding("UTF-8"))
        worksheet.add_cell(36 + count, 16, work_info.end_time.strftime("%-H時%-M分%-S秒").to_s.force_encoding("UTF-8"))
        worksheet.add_cell(36 + count, 20, "#{work_info.work_time}分".to_s.force_encoding("UTF-8"))
        count += 1
      end
    end
    workbook.write('app/assets/excel/write_report1.xlsx')
    session[:file_path] = 'app/assets/excel/write_report1.xlsx'
    #session[:file_path] = 'public/write_report1.xlsx'
    redirect_to download_excel_path
  end
  def write_excel2
    id = params[:student_id]
    teaching_assistant = TeachingAssistant.find_by("number LIKE ?", "#{id}")
    shifts = Assignment.where("teaching_assistant_id LIKE ?", "#{teaching_assistant.id}")
    workbook = RubyXL::Parser.parse('app/assets/excel/report_type2.xlsx')
    
    worksheet = workbook[0]
    worksheet.add_cell(2, 4, teaching_assistant.name)
    worksheet.add_cell(2, 18, teaching_assistant.number)
    shifts.each_with_index do |shift, index|
      work_infos = WorkHour.where("assignment_id LIKE ?", "#{shift.id}") 
      work_infos.each_with_index do |work_info, index2|
        month = work_info.start_time.month
        day = work_info.start_time.day
        search_month(month,day,work_info,worksheet)
      end
    end
    workbook.write('app/assets/excel/write_report2.xlsx')
    session[:file_path] = 'app/assets/excel/write_report2.xlsx'  
    #excel_to_pdf('app/assets/excel/write_report2.xlsx', 'app/assets/pdf/write_report2.pdf')

    redirect_to download_excel_path
  end
  def download_excel
    file_path = session[:file_path]
    send_file file_path, type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', disposition: 'attachment'
  end



end


