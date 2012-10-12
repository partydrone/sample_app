class MicropostsController < ApplicationController
  before_filter :find_micropost
  before_filter :signed_in_user

  def create
  end

  def destroy
  end

private

  def find_micropost
    @micropost = Micropost.find(params[:id]) if params[:id]
  end
end
