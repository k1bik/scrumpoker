class RoomsController < ApplicationController
  before_action :authenticate_user

  def index
    @rooms = Room.where(owner: current_user).order(created_at: :desc)
  end

  def show
    @room = Room.friendly.find(params[:id])
    @room.users << current_user unless @room.users.find_by(id: current_user.id)
    @current_user_estimate = UserRoomEstimate.find_by(user: current_user, room: @room)
    @estimates = @room.estimates.split(UserRoomEstimate::SEPARATOR)
    @players = @room.users
  end

  def new
    @room = Room.new
  end

  def edit
    @room = Room.find(params[:id])
  end

  def create
    @room = Room.new(room_params.merge({owner: current_user}))
    @room.users << current_user

    respond_to do |format|
      if @room.save
        format.json { render :show, status: :created, location: @room }
        format.turbo_stream {}
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @room.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
  end

  private

  def room_params
    params.require(:room).permit(:name, :estimates)
  end
end
