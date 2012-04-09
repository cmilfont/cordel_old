class AuthorsController < ApplicationController

  respond_to :html, :json

  def index
    query = params[:query]
    resultados = Sunspot.search(Author) do
      keywords(query)
    end
    @ext_response = {
      :authors => resultados.results
    }    
    respond_with @ext_response
  end
  
  def show
    @author = Author.find params[:id]
    respond_with @author
  end
  
  def create
    @author = Author.create(params[:author])
    respond_with @author
  end
  
end