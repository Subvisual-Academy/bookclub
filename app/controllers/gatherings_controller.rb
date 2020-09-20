class GatheringsController < ApplicationController
  before_action :require_login, only: %i[edit update]
  before_action :require_moderator, only: %i[new create destroy]

  caches_action :index, layout: false, unless: -> { current_user }

  def index
    @gatherings = Gathering.group_by_year
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
      redirect_to gatherings_path, notice: "Gathering was successfully created."
    else
      flash.now[:notice] = "Invalid field"
      render new_gathering_path, status: :bad_request
    end
  end

  def update
    @gathering = Gathering.find(params[:id])

    if @gathering.update(gathering_params)
      redirect_to gatherings_path, notice: "Gathering was successfully updated."
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
                                               user_id book_id special])
  end

  def require_moderator
    return if current_user&.moderator

    head :unauthorized
  end
end
