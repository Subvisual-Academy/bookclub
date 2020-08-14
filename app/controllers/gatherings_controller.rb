class GatheringsController < ApplicationController
  before_action :require_login, only: %i[new edit create update destroy]

  def index
    @gatherings = Gathering.order("date DESC")
    @first_year = @gatherings.first&.date&.year || 0
    @last_year = @gatherings.last&.date&.year || 0
  end

  def show
    @gathering = Gathering.find(params[:id])
  end

  def new
    @gathering = Gathering.new
  end

  def edit
    @gathering = Gathering.find(params[:id])
  end

  def create
    @gathering = Gathering.new(gathering_params)

    if @gathering.save
      SlackNotifier.publish(root_url, @gathering.date, gathering_path(@gathering))
      redirect_to gatherings_path, notice: "Gathering was successfully created."
    else
      flash.now[:notice] = "Invalid field"
      render new_gathering_path, status: :bad_request
    end
  end

  def update
    @gathering = Gathering.find(params[:id])

    if @gathering.update(gathering_params)
      redirect_to @gathering, notice: "Gathering was successfully updated."
    else
      flash.now[:notice] = "Invalid field"
      render :edit, status: :bad_request
    end
  end

  def destroy
    @gathering = Gathering.find(params[:id])

    @gathering.destroy

    redirect_to gatherings_path, notice: "Gathering was successfully destroyed."
  end

  private

  def gathering_params
    params.require(:gathering).
      permit(:date, :special_presentation,
             book_presentations_attributes: %i[_destroy id gathering_id
                                               user_id book_id belongs_special_presentation])
  end
end
