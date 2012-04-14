class BooksController < ApplicationController

  respond_to :html, :json

  def index
    @user = current_user
    if(@user.present?)
      @books = Book.mybooks(current_user)
      @shelves = Shelf.where(:user_id => @user.id)
    else
      @books = []
      @shelves = []
    end
    
  end
  
  def search
    
    query    = params[:query]    || ""
    page     = params[:page]     || 1
    per_page = params[:per_page] || 10
    
    busca = Book.search do
      fulltext query do
        highlight :pages_content, :author, :title, :publisher, :fragment_size => 0
      end
      paginate :page => page, :per_page => per_page
    end
    
    

    busca.each_hit_with_result do |hit, result|

      result.author_highlighted        = hit.highlight(:author).format { |word| "<span class='highlight'>#{word}</span>" } rescue ""
      result.title_highlighted         = hit.highlight(:title).format { |word| "<span class='highlight'>#{word}</span>" } rescue ""
      result.publisher_highlighted     = hit.highlight(:publisher).format { |word| "<span class='highlight'>#{word}</span>" } rescue ""
      
      hit.highlights(:pages_content).each{|high|
        result.pages_content_highlighted = high.format { |word| "<span class='highlight'>#{word}</span>" } rescue ""
      }
      
    end

    @books = busca.results
    respond_with @books, :methods => [:author_highlighted, :pages_content_highlighted, :title_highlighted, :publisher_highlighted, :thumb_image_path],
                         :include => [:author]
  end
  
  def new
    @user = current_user
  end
  
  def show
    @user = current_user
    @book = Book.find(params[:id])
    respond_with @book, :include => :author, :methods => [:thumb_image_path]
  end

  def create
    @book = Book.new(params[:book])
    @book.save
    if @book.valid?
      Book.deliver(@book.id)
      render :text => {
        :success => true,
        :book => @book.to_json(:methods => :thumb_image_path)
      }.to_json
    else
      render :text => {
        :success => false,
        :errors => @book.errors
      }.to_json
    end
  end
  
  def update
    @book = Book.find params[:id]
    params[:book].delete :id
    @book.update_attributes(params[:book])    
    respond_with @book
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