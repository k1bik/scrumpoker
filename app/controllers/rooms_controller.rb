class RoomsController < ApplicationController
  before_action :authenticate_user

  def index
    @rooms = Room.where(owner: current_user).order(created_at: :desc)
  end

  def show
    @room = Room.friendly.find(params[:id])

    if @room.users.find_by(id: current_user.id).nil?
      @room.users << current_user
      user_room = UserRoomEstimate.create(user: current_user, room: @room)
    end

    @user_room = user_room || UserRoomEstimate.find_by(user: current_user, room: @room)
    @estimates = @room.estimates.split(',')
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
