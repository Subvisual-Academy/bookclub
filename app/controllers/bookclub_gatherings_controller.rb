class BookclubGatheringsController < ApplicationController
  before_action :require_login, only: %i[new edit create update destroy]
  def index
    @bookclub_gatherings = BookclubGathering.all
  end

  def show
    @bookclub_gathering = BookclubGathering.find(params[:id])
  end

  def new
    @bookclub_gathering = BookclubGathering.new
  end

  def edit
    @bookclub_gathering = BookclubGathering.find(params[:id])
  end

  def create
    @bookclub_gathering = BookclubGathering.new(bookclub_gathering_params)

    if @bookclub_gathering.save
      SlackNotifier.publish(root_url, @bookclub_gathering.date, bookclub_gathering_path(@bookclub_gathering))
      redirect_to bookclub_gatherings_path, notice: "Gathering was successfully created."
    else
      flash.now[:notice] = "Invalid field"
      render new_bookclub_gathering_path, status: :bad_request
    end
  end

  def update
    @bookclub_gathering = BookclubGathering.find(params[:id])

    if @bookclub_gathering.update(bookclub_gathering_params)
      redirect_to @bookclub_gathering, notice: "Gathering was successfully updated."
    else
      flash.now[:notice] = "Invalid field"
      render :edit, status: :bad_request
    end
  end

  def destroy
    @bookclub_gathering = BookclubGathering.find(params[:id])

    @bookclub_gathering.destroy

    redirect_to bookclub_gatherings_path, notice: "Gathering was successfully destroyed."
  end

  private

  def bookclub_gathering_params
    params.require(:bookclub_gathering).
      permit(:date, :special_presentation,
             book_presentations_attributes: %i[_destroy id bookclub_gathering_id
                                               user_id book_id belongs_special_presentation])
  end
end
