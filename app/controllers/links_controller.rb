class LinksController < ApplicationController
  before_action :require_user, :only => [:new, :create, :edit, :update]
  before_action :check_if_current_user_is_owner, :only => [:edit, :update]

  def index
    if params[:tag]
      @tag = Tag.find_by_name(params[:tag])
      @links = @tag.links.order("vote_total DESC").page(params[:page] || 1).per(10)
    else
      @links = Link.order("vote_total DESC").page(params[:page] || 1).per(10)
    end
  end

  def show
    @link = Link.find(params[:id])
  end

  def new
    @link = Link.new
  end

  def create
    @link = Link.new(link_params)
    @link.user = @current_user
    if @link.save
      flash[:success] = "Wahoo! You've submitted an awesome new link!"
      redirect_to root_path
    else
      render "new"
    end
  end

  def edit
  end

  def update
    if @link.update(link_params)
      redirect_to root_url
    else
      render "edit"
    end
  end

  def click
    @link = Link.find(params[:id])
    @link.votes.create
    redirect_to @link.url
  end


  private

  def link_params
    params.require(:link).permit(:title, :url, :summary, :tag_names)
  end

  def check_if_current_user_is_owner
    @link = Link.find(params[:id])
    unless @link.user == @current_user
      flash[:danger] = "That's not your link, bub!"
      redirect_to root_url
    end
  end

end
