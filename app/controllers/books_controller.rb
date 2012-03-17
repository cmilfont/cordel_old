class BooksController < ApplicationController

  respond_to :html, :json

  def index
    @user = current_user
    if(@user.present?)
      @books = Book.mybooks(current_user)
    else
      @books = Book.all
    end
  end
  
  def new
    @user = current_user
  end
  
  def show
    @user = current_user
    @book = Book.find(params[:id])
  end

  def create
    @book = Book.new(params[:book])
    @book.save
    Book.deliver(@book.id)
    render :text => {
      :success => "ok",
      :book => @book.to_json(:methods => :thumb_image_path)
    }.to_json
  end
  
  def destroy
    @book = Book.find(params[:id])

    if require_owner(@book)
      Sunspot.remove @book
      @book.destroy
      respond_with @book

    end

  end
  
  private
  def require_owner(book)
    unless current_user.owner_of(book)
      flash[:notice] = "You must be owner to access this page"
      redirect_to home_path
      return false
    end
    return true
  end
  
end