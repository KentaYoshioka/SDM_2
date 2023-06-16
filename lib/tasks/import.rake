require 'csv'

# rake import:course_data
namespace :import do
  #このdescはdescribeのdesc
  desc "Import data from csv"
  task :all => [:course, :teaching_assistant]

  task course: :environment do
    path = File.join Rails.root, "db/courses.csv"
    puts "path: #{path}"
    list = []
    CSV.foreach(path, headers: true) do |row_Course|
      list << {
          year: row_Course[1],
          term: row_Course[2],
          number: row_Course[3],
          name: row_Course[4],
          instructor: row_Course[5],
          time_budget: row_Course[6],
          description: row_Course[7]
      }
    end
    puts "start to create course data"
    begin
      Course.create!(list) #クラス名注意
      puts "completed!!"
    rescue ActiveModel::UnknownAttributeError => invalid
      puts "raised error : unKnown attribute of course"
    end
  end

  task teaching_assistant: :environment do
    path = File.join Rails.root, "db/teaching_assistants.csv"
    puts "path: #{path}"
    list = []
    CSV.foreach(path, headers: true) do |row|
      list << {
          year: row[1],
          number: row[2],
          grade: row[3],
          name: row[4],
          labo: row[5],
          description: row[6]
      }
    end
    puts "start to create teaching_assistant data"
    begin
      TeachingAssistant.create!(list) #クラス名注意
      puts "completed!!"
    rescue ActiveModel::UnknownAttributeError => invalid
      puts "raised error : unKnown attribute of teaching_assistant"
    end
  end
end

