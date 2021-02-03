class ActivitiesController < ApplicationController

  # GET /activities or /activities.json
  def index
    @activities = Activity.includes(:user).all
  end

  # GET /activities/1 or /activities/1.json
  def show
    @activity = Activity.find(params[:id])
  end

  # GET /activities/new
  def new
    @activity = Activity.new
  end

  # GET /activities/1/edit
  def edit
    authorize!(activity)
  end

  # POST /activities or /activities.json
  def create
    @activity = current_user.activities.new(activity_params)

    respond_to do |format|
      if activity.save
        format.html { redirect_to activity, notice: "Activity was successfully created." }
        format.json { render :show, status: :created, location: activity }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: activity.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /activities/1 or /activities/1.json
  def update
    authorize!(activity)

    respond_to do |format|
      if activity.update(activity_params)
        format.html { redirect_to activity, notice: "Activity was successfully updated." }
        format.json { render :show, status: :ok, location: activity }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: activity.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /activities/1 or /activities/1.json
  def destroy
    authorize!(activity)

    activity.destroy
    respond_to do |format|
      format.html { redirect_to activities_url, notice: "Activity was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def download_csv
    activities = Activity.includes(:user).order(:start_at).all

    result = Activities::GenerateCsv.call(activities)

    respond_to do |format|
      case result
      when Success
        format.csv { send_data(result.value!, filename: "activities.#{Time.zone.now.to_i}.csv") }
      when Failure
        format.json { render json: result.failure, status: :unprocessable_entity }
      end
    end
  end

  private

  def activity
    # todo: move to repository
    @activity ||= current_user.activities.find(params[:id])
  end

  def activity_params
    params.require(:activity).permit(*%i[title activity_type short_description start_at end_at])
  end
end
