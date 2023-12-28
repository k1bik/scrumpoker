class RoomsController < ApplicationController
  before_action :authenticate_user

  def index
    @rooms = Room.where(owner: current_user).order(created_at: :desc)
  end

  def show
    @room = Room.friendly.find(params[:id])
    @room.users << current_user unless @room.users.find_by(id: current_user.id)
    @estimates = @room.estimates_array
    @players = @room.active_players
    TurboFrames::Updater.new(@room, current_user).estimate_table
  end

  def new
    @room = Room.new
  end

  def edit
    @room = Room.friendly.find(params[:id])
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
    @room = Room.friendly.find(params[:id])

    if @room.update(room_params)
      TurboFrames::Updater.new(@room, current_user).room_estimates
    else
      render :edit, room: @room
    end
  end

  def destroy
    room = Room.friendly.find(params[:id])
    room.destroy
    redirect_to root_path
  end

  private

  def room_params
    params.require(:room).permit(:name, :estimates)
  end
end
