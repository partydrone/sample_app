class StaticPagesController < ApplicationController
  def home
    if current_user
      @micropost  = current_user.microposts.new
      @feed_items = current_user.feed.paginate(page: params[:page])
    end
  end

  def about
  end

  def contact
  end

  def help
  end
end