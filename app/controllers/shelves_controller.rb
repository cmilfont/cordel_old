class ShelvesController < ApplicationController

  respond_to :html, :json

  def index
    @user = current_user
    if(@user.present?)
      @shelves = Shelf.where(:user_id => current_user.id).includes(:books)
    end
    respond_with @shelves, :include => { :books => { :methods => [:thumb_image_path] } }
  end
  
  def show
    @shelf = Shelf.find params[:id]
    respond_with @shelf, :include => { :books => { :methods => [:thumb_image_path] } }
  end
  
  def create
    @shelf = Shelf.new(params[:shelf])
    @shelf.save
    respond_with @shelf, :include => { :books => { :methods => [:thumb_image_path] } }
  end
  
end
