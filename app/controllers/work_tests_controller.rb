class WorkTestsController < ApplicationController
  before_action :set_work_test, only: %i[ show edit update destroy ]

  # GET /work_tests or /work_tests.json
  def index
    @work_tests = WorkTest.all
  end

  # GET /work_tests/1 or /work_tests/1.json
  def show
  end

  # GET /work_tests/new
  def new
    @work_test = WorkTest.new
  end

  # GET /work_tests/1/edit
  def edit
  end

  # POST /work_tests or /work_tests.json
  def create
    @work_test = WorkTest.new(work_test_params)

    respond_to do |format|
      if @work_test.save
        format.html { redirect_to work_test_url(@work_test), notice: "Work test was successfully created." }
        format.json { render :show, status: :created, location: @work_test }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @work_test.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /work_tests/1 or /work_tests/1.json
  def update
    respond_to do |format|
      if @work_test.update(work_test_params)
        format.html { redirect_to work_test_url(@work_test), notice: "Work test was successfully updated." }
        format.json { render :show, status: :ok, location: @work_test }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @work_test.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /work_tests/1 or /work_tests/1.json
  def destroy
    @work_test.destroy

    respond_to do |format|
      format.html { redirect_to work_tests_url, notice: "Work test was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_work_test
      @work_test = WorkTest.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def work_test_params
      params.require(:work_test).permit(:date, :start_time, :end_time, :actual_working_time)
    end
end
