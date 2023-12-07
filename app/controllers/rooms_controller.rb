class RoomsController < ApplicationController
  before_action :authenticate_user

  def index
    @rooms = Room.all.order(name: :desc)
  end

  def show
  end

  def new
    @room = Room.new
  end

  def edit
  end

  def create
  end

  def update
  end
end
