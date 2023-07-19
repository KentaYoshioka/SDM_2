require 'csv'
require 'set'

def append_to_old_csv(old_file, new_file)
  old_records = CSV.read(old_file, headers: true)
  new_records = CSV.read(new_file, headers: true)

  if old_records.empty?
    old_records << new_records.headers
  end

  old_records << new_records

  CSV.open(old_file, 'a', headers: true, encoding: Encoding::UTF_8) do |csv|
    if old_records.empty?
      csv << new_records.headers
    end
    CSV.foreach(new_file) do |row|
      csv << row
    end
  end
end

# rake import:course_data
namespace :import do
  #このdescはdescribeのdesc
  desc "Import data from csv"
  task :all => [:course, :teaching_assistant]

  task course: :environment do
    path = File.join Rails.root, "db/courses.csv"
    path_old = File.join Rails.root, "db/courses_old.csv"
    puts "path: #{path}"
    puts "path_old: #{path_old}"
    list_diff = []
    
    old_file_data = Set.new
    CSV.foreach(path_old, headers: true) do |row|
      data = []
      data << {
        year: row[1],
        term: row[2],
        number: row[3],
        name: row[4],
        instructor: row[5],
        time_budget: row[6],
        description: row[7]   
      }
      old_file_data.add(data)
    end
    
    CSV.foreach(path, headers: true) do |row|
      data = []
      data << {
        year: row[1],
        term: row[2],
        number: row[3],
        name: row[4],
        instructor: row[5],
        time_budget: row[6],
        description: row[7]   
      }
      # csv1に存在しない行をlistに追加
      unless old_file_data.include?(data)
        list_diff << data
      end
    end

    puts "start to create course data"
    begin
      Course.create!(list_diff) #クラス名注意
      puts "completed!!"
    rescue ActiveModel::UnknownAttributeError => invalid
      puts "raised error : unKnown attribute of course"
    end
    
    append_to_old_csv(path_old,path)
    puts "Completed appending data to courses_old.csv"

  end

  task teaching_assistant: :environment do
    path = File.join Rails.root, "db/teaching_assistants.csv"
    path_old = File.join Rails.root, "db/teaching_assistants_old.csv"
    puts "path: #{path}"
    puts "path_old: #{path_old}"
    list_diff = []
  
    old_file_data = Set.new
    CSV.foreach(path_old, headers: true) do |row|
      data = []
      data << {
        year: row[1],
        number: row[2],
        grade: row[3],
        name: row[4],
        labo: row[5],
        description: row[6]
      }
      old_file_data.add(data)
    end
    
    CSV.foreach(path, headers: true) do |row|
      data = []
      data << {
        year: row[1],
        number: row[2],
        grade: row[3],
        name: row[4],
        labo: row[5],
        description: row[6] 
      }
      # csv1に存在しない行をlistに追加
      unless old_file_data.include?(data)
        list_diff << data
      end
    end

    puts "start to create teaching_assistant data"
    begin
      TeachingAssistant.create!(list_diff) #クラス名注意
      puts "completed!!"
    rescue ActiveModel::UnknownAttributeError => invalid
      puts "raised error : unKnown attribute of teaching_assistant"
    end

    append_to_old_csv(path_old,path)
    puts "Completed appending data to teaching_assistant_old.csv"
  end
end