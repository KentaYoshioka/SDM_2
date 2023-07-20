class TeachingAssistantsController < ApplicationController
include ApplicationHelper
  def index
    fiscal_year = current_fiscal_year
    @TA_data = TeachingAssistant.where(year:fiscal_year)
  end
end
