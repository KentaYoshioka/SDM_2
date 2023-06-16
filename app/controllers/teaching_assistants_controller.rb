class TeachingAssistantsController < ApplicationController
  def index
    @TA_data = TeachingAssistants.all
  end
end
