class Api::GatheringsController < Api::BaseController
  def index
    @gatherings = Gathering.includes(:books).order("date DESC").
      page(params[:page]).
      per(params[:per])
  end

  def show
    @gathering = Gathering.find(params[:id])
  end
end
