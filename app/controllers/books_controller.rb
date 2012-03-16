class BooksController < ApplicationController

  respond_to :html, :json

  def create
    @book = Book.new(params[:book])
    @book.save
    render :text => {
      :success => "ok",
      :book => @book
    }.to_json
  end
  
end