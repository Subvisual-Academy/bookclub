class GatheringsController < ApplicationController
  before_action :require_login, only: %i[new edit create update destroy]

  def index
    @gatherings = Gathering.group_by_year
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
    gathering_params = process_params

    @gathering = Gathering.new(gathering_params)

    if @gathering.save
      redirect_to gatherings_path, notice: "Gathering was successfully created."
    else
      flash.now[:notice] = "Invalid field"
      render new_gathering_path, status: :bad_request
    end
  end

  def update
    gathering_params = process_params
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
                                               user_id book_id special])
  end

  def process_params
    params = gathering_params
    if params["book_presentations_attributes"]
      book_presentations_attributes = params["book_presentations_attributes"].to_unsafe_h
      book_presentations_attributes.transform_values { |presentation_params| process_user_id(presentation_params) }
      book_presentations_attributes.transform_values { |presentation_params| process_book_id(presentation_params) }
      params["book_presentations_attributes"] = book_presentations_attributes
    end
    params
  end

  def process_user_id(presentation_params)
    user = User.find_by(name: presentation_params[:user_id])
    presentation_params[:user_id] = user.id if user
  end

  def process_book_id(presentation_params)
    book = Book.find_by(title: presentation_params[:book_id])
    presentation_params[:book_id] = book.id if book
  end
end
