class RelationshipsController < ApplicationController
  before_filter :signed_in_user
  before_filter :find_relationship

  def create
    @user = User.find(params[:relationship][:followed_id])
    current_user.follow! @user
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end

  def destroy
    @user = @relationship.followed
    current_user.unfollow! @user
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end

private
  
  def find_relationship
    @relationship = Relationship.find(params[:id]) if params[:id]
  end
end