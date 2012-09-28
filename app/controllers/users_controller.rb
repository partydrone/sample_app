class UsersController < ApplicationController
  before_filter :find_user

  def show
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      render :new
    end
  end
  
private

  def find_user
    @user = User.find(params[:id]) if params[:id]
  end
end
