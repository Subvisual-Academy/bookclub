class GatheringsController < ApplicationController
  before_action :require_login, only: %i[edit update]
  before_action :require_moderator, only: %i[new create destroy]

  def index
    @gatherings = Gathering.group_by_year
  end

  def show
    @gathering = Gathering.find(params[:id])
    @other_users_presentations = @gathering.book_presentations.reject(&:special).group_by(&:user_id)
    @user_presentations = @gathering.book_presentations.select(&:special).group_by(&:user_id)
  end

  def new
    @gathering = Gathering.new(date: Time.current)
  end

  def edit
    @gathering = Gathering.find(params[:id])
  end

  def create
    @gathering = Gathering.new(gathering_params)

    if @gathering.save
      redirect_to gatherings_path, notice: "Gathering was successfully created."
    else
      flash[:notice] = "Invalid field"
      redirect_to new_gathering_path
    end
  end

  def update
    @gathering = Gathering.find(params[:id])

    if @gathering.update(gathering_params)
      redirect_to gatherings_path, notice: "Gathering was successfully updated."
    else
      flash[:notice] = "Invalid field"
      redirect_to edit_gathering_path
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
