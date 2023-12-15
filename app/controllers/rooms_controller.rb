class RoomsController < ApplicationController
  before_action :authenticate_user

  def show
    @room = Room.find(params[:id])

    if @room.users.find_by(id: current_user.id).nil?
      @room.users << current_user
    end

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

  def find
    @room = Room.find_by_name(params[:room][:name])

    respond_to do |format|
      if @room
        format.html { redirect_to room_path(@room)}
      else
        format.turbo_stream do
          render turbo_stream: turbo_stream.prepend("find_search", partial: "rooms/no")
        end
      end
    end
  end

  private

  def room_params
    params.require(:room).permit(:name, :estimates)
  end
end
