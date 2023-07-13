class CoursesController < ApplicationController
  include ApplicationHelper
  def index
    fiscal_year = current_fiscal_year
    @courses = Course.where(year:fiscal_year)
  end
end
