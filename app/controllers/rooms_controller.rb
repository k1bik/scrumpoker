class RoomsController < ApplicationController
  before_action :authenticate_user

  def index
    @rooms = Room.all.order(name: :desc)
  end

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
 
    if @room.save
      redirect_to @room, notice: 'Room was successfully created.'
    else
      render :new
    end
  end

  def update
  end

  private

  def room_params
    params.require(:room).permit(:name, :estimates)
  end
end
