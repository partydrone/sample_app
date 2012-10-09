class UsersController < ApplicationController
  before_filter :find_user
  before_filter :signed_in_user, only: [:index, :edit, :update]
  before_filter :correct_user, only: [:edit, :update]
  before_filter :admin_user, only: :destroy

  def index
    @users = User.paginate(page: params[:page])
  end

  def show
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @user.update_attributes(params[:user])
      sign_in @user
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render :edit
    end
  end

  def destroy
    @user.destroy
    flash[:success] = "User destroyed."
    redirect_to users_path
  end
  
private

  def find_user
    @user = User.find(params[:id]) if params[:id]
  end

  def signed_in_user
    unless current_user
      store_location
      redirect_to signin_path, notice: 'Please sign in.'
    end
  end

  def correct_user
    redirect_to root_path unless current_user == @user
  end

  def admin_user
    redirect_to root_path unless current_user.admin?
  end
end
