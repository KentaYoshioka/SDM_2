class Assignment < ApplicationRecord
  belongs_to :course
  belongs_to :teaching_assistant
  has_many :work_hour, dependent: :destroy
end
