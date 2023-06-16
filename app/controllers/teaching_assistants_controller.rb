class TeachingAssistantsController < ApplicationController
  def index
    @TA_data = TeachingAssistant.all
  end
end
