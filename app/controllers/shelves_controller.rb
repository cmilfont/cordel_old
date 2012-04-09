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
    #@shelf = Shelf.find params[:id]
    #respond_with @shelf, :include => { :books => { :methods => [:thumb_image_path] } }
    
    render :json => {
      "created_at" => "2012-04-06T21:12:39Z",
      "id" => 1,
      "name" => "Test Driven Development",
      "updated_at" => "2012-04-06T21:12:39Z",
      "user_id" => 1,
      "books" => [
        {"author_id" => 3,"cover_img_uuid" => "2af1dff0-5400-012f-5d0f-48bcc8899524","created_at" => "2012-03-19T14:45:49Z","edition" => "","file_content_type" => "application/pdf","file_file_name" => "5things_presentation_102811.pdf","file_file_size" => 2723092,"file_updated_at" => "2012-03-19T14:45:49Z","id" => 49,"index_erro" => nil,"publisher" => "","title" => "teste","updated_at" => "2012-03-24T09:59:45Z","user_id" => 1,"year" => 2003,"thumb_image_path" => "/images/covers/cover_2af1dff0-5400-012f-5d0f-48bcc8899524_thumb.png"},
        {"author_id" => 3,"cover_img_uuid" => "2af1dff0-5400-012f-5d0f-48bcc8899524","created_at" => "2012-03-19T14:45:49Z","edition" => "","file_content_type" => "application/pdf","file_file_name" => "5things_presentation_102811.pdf","file_file_size" => 2723092,"file_updated_at" => "2012-03-19T14:45:49Z","id" => 50,"index_erro" => nil,"publisher" => "","title" => "teste","updated_at" => "2012-03-24T09:59:45Z","user_id" => 1,"year" => 2003,"thumb_image_path" => "/images/covers/cover_2af1dff0-5400-012f-5d0f-48bcc8899524_thumb.png"},
        {"author_id" => 3,"cover_img_uuid" => "2af1dff0-5400-012f-5d0f-48bcc8899524","created_at" => "2012-03-19T14:45:49Z","edition" => "","file_content_type" => "application/pdf","file_file_name" => "5things_presentation_102811.pdf","file_file_size" => 2723092,"file_updated_at" => "2012-03-19T14:45:49Z","id" => 51,"index_erro" => nil,"publisher" => "","title" => "teste","updated_at" => "2012-03-24T09:59:45Z","user_id" => 1,"year" => 2003,"thumb_image_path" => "/images/covers/cover_2af1dff0-5400-012f-5d0f-48bcc8899524_thumb.png"},
        {"author_id" => 3,"cover_img_uuid" => "2af1dff0-5400-012f-5d0f-48bcc8899524","created_at" => "2012-03-19T14:45:49Z","edition" => "","file_content_type" => "application/pdf","file_file_name" => "5things_presentation_102811.pdf","file_file_size" => 2723092,"file_updated_at" => "2012-03-19T14:45:49Z","id" => 52,"index_erro" => nil,"publisher" => "","title" => "teste","updated_at" => "2012-03-24T09:59:45Z","user_id" => 1,"year" => 2003,"thumb_image_path" => "/images/covers/cover_2af1dff0-5400-012f-5d0f-48bcc8899524_thumb.png"},
        {"author_id" => 3,"cover_img_uuid" => "2af1dff0-5400-012f-5d0f-48bcc8899524","created_at" => "2012-03-19T14:45:49Z","edition" => "","file_content_type" => "application/pdf","file_file_name" => "5things_presentation_102811.pdf","file_file_size" => 2723092,"file_updated_at" => "2012-03-19T14:45:49Z","id" => 53,"index_erro" => nil,"publisher" => "","title" => "teste","updated_at" => "2012-03-24T09:59:45Z","user_id" => 1,"year" => 2003,"thumb_image_path" => "/images/covers/cover_2af1dff0-5400-012f-5d0f-48bcc8899524_thumb.png"},
        {"author_id" => 3,"cover_img_uuid" => "2af1dff0-5400-012f-5d0f-48bcc8899524","created_at" => "2012-03-19T14:45:49Z","edition" => "","file_content_type" => "application/pdf","file_file_name" => "5things_presentation_102811.pdf","file_file_size" => 2723092,"file_updated_at" => "2012-03-19T14:45:49Z","id" => 54,"index_erro" => nil,"publisher" => "","title" => "teste","updated_at" => "2012-03-24T09:59:45Z","user_id" => 1,"year" => 2003,"thumb_image_path" => "/images/covers/cover_2af1dff0-5400-012f-5d0f-48bcc8899524_thumb.png"},
        {"author_id" => 3,"cover_img_uuid" => "2af1dff0-5400-012f-5d0f-48bcc8899524","created_at" => "2012-03-19T14:45:49Z","edition" => "","file_content_type" => "application/pdf","file_file_name" => "5things_presentation_102811.pdf","file_file_size" => 2723092,"file_updated_at" => "2012-03-19T14:45:49Z","id" => 55,"index_erro" => nil,"publisher" => "","title" => "teste","updated_at" => "2012-03-24T09:59:45Z","user_id" => 1,"year" => 2003,"thumb_image_path" => "/images/covers/cover_2af1dff0-5400-012f-5d0f-48bcc8899524_thumb.png"},
        {"author_id" => 3,"cover_img_uuid" => "2af1dff0-5400-012f-5d0f-48bcc8899524","created_at" => "2012-03-19T14:45:49Z","edition" => "","file_content_type" => "application/pdf","file_file_name" => "5things_presentation_102811.pdf","file_file_size" => 2723092,"file_updated_at" => "2012-03-19T14:45:49Z","id" => 56,"index_erro" => nil,"publisher" => "","title" => "teste","updated_at" => "2012-03-24T09:59:45Z","user_id" => 1,"year" => 2003,"thumb_image_path" => "/images/covers/cover_2af1dff0-5400-012f-5d0f-48bcc8899524_thumb.png"},
        {"author_id" => 3,"cover_img_uuid" => "2af1dff0-5400-012f-5d0f-48bcc8899524","created_at" => "2012-03-19T14:45:49Z","edition" => "","file_content_type" => "application/pdf","file_file_name" => "5things_presentation_102811.pdf","file_file_size" => 2723092,"file_updated_at" => "2012-03-19T14:45:49Z","id" => 57,"index_erro" => nil,"publisher" => "","title" => "teste","updated_at" => "2012-03-24T09:59:45Z","user_id" => 1,"year" => 2003,"thumb_image_path" => "/images/covers/cover_2af1dff0-5400-012f-5d0f-48bcc8899524_thumb.png"},
        {"author_id" => 3,"cover_img_uuid" => "2af1dff0-5400-012f-5d0f-48bcc8899524","created_at" => "2012-03-19T14:45:49Z","edition" => "","file_content_type" => "application/pdf","file_file_name" => "5things_presentation_102811.pdf","file_file_size" => 2723092,"file_updated_at" => "2012-03-19T14:45:49Z","id" => 58,"index_erro" => nil,"publisher" => "","title" => "teste","updated_at" => "2012-03-24T09:59:45Z","user_id" => 1,"year" => 2003,"thumb_image_path" => "/images/covers/cover_2af1dff0-5400-012f-5d0f-48bcc8899524_thumb.png"},
        {"author_id" => 3,"cover_img_uuid" => "2af1dff0-5400-012f-5d0f-48bcc8899524","created_at" => "2012-03-19T14:45:49Z","edition" => "","file_content_type" => "application/pdf","file_file_name" => "5things_presentation_102811.pdf","file_file_size" => 2723092,"file_updated_at" => "2012-03-19T14:45:49Z","id" => 59,"index_erro" => nil,"publisher" => "","title" => "teste","updated_at" => "2012-03-24T09:59:45Z","user_id" => 1,"year" => 2003,"thumb_image_path" => "/images/covers/cover_2af1dff0-5400-012f-5d0f-48bcc8899524_thumb.png"},
        {"author_id" => 3,"cover_img_uuid" => "2af1dff0-5400-012f-5d0f-48bcc8899524","created_at" => "2012-03-19T14:45:49Z","edition" => "","file_content_type" => "application/pdf","file_file_name" => "5things_presentation_102811.pdf","file_file_size" => 2723092,"file_updated_at" => "2012-03-19T14:45:49Z","id" => 60,"index_erro" => nil,"publisher" => "","title" => "teste","updated_at" => "2012-03-24T09:59:45Z","user_id" => 1,"year" => 2003,"thumb_image_path" => "/images/covers/cover_2af1dff0-5400-012f-5d0f-48bcc8899524_thumb.png"},
        {"author_id" => 3,"cover_img_uuid" => "2af1dff0-5400-012f-5d0f-48bcc8899524","created_at" => "2012-03-19T14:45:49Z","edition" => "","file_content_type" => "application/pdf","file_file_name" => "5things_presentation_102811.pdf","file_file_size" => 2723092,"file_updated_at" => "2012-03-19T14:45:49Z","id" => 61,"index_erro" => nil,"publisher" => "","title" => "teste","updated_at" => "2012-03-24T09:59:45Z","user_id" => 1,"year" => 2003,"thumb_image_path" => "/images/covers/cover_2af1dff0-5400-012f-5d0f-48bcc8899524_thumb.png"},
        {"author_id" => 3,"cover_img_uuid" => "2af1dff0-5400-012f-5d0f-48bcc8899524","created_at" => "2012-03-19T14:45:49Z","edition" => "","file_content_type" => "application/pdf","file_file_name" => "5things_presentation_102811.pdf","file_file_size" => 2723092,"file_updated_at" => "2012-03-19T14:45:49Z","id" => 62,"index_erro" => nil,"publisher" => "","title" => "teste","updated_at" => "2012-03-24T09:59:45Z","user_id" => 1,"year" => 2003,"thumb_image_path" => "/images/covers/cover_2af1dff0-5400-012f-5d0f-48bcc8899524_thumb.png"},
        {"author_id" => 3,"cover_img_uuid" => "2af1dff0-5400-012f-5d0f-48bcc8899524","created_at" => "2012-03-19T14:45:49Z","edition" => "","file_content_type" => "application/pdf","file_file_name" => "5things_presentation_102811.pdf","file_file_size" => 2723092,"file_updated_at" => "2012-03-19T14:45:49Z","id" => 63,"index_erro" => nil,"publisher" => "","title" => "teste","updated_at" => "2012-03-24T09:59:45Z","user_id" => 1,"year" => 2003,"thumb_image_path" => "/images/covers/cover_2af1dff0-5400-012f-5d0f-48bcc8899524_thumb.png"},
        {"author_id" => 3,"cover_img_uuid" => "2af1dff0-5400-012f-5d0f-48bcc8899524","created_at" => "2012-03-19T14:45:49Z","edition" => "","file_content_type" => "application/pdf","file_file_name" => "5things_presentation_102811.pdf","file_file_size" => 2723092,"file_updated_at" => "2012-03-19T14:45:49Z","id" => 64,"index_erro" => nil,"publisher" => "","title" => "teste","updated_at" => "2012-03-24T09:59:45Z","user_id" => 1,"year" => 2003,"thumb_image_path" => "/images/covers/cover_2af1dff0-5400-012f-5d0f-48bcc8899524_thumb.png"},
        {"author_id" => 3,"cover_img_uuid" => "2af1dff0-5400-012f-5d0f-48bcc8899524","created_at" => "2012-03-19T14:45:49Z","edition" => "","file_content_type" => "application/pdf","file_file_name" => "5things_presentation_102811.pdf","file_file_size" => 2723092,"file_updated_at" => "2012-03-19T14:45:49Z","id" => 65,"index_erro" => nil,"publisher" => "","title" => "teste","updated_at" => "2012-03-24T09:59:45Z","user_id" => 1,"year" => 2003,"thumb_image_path" => "/images/covers/cover_2af1dff0-5400-012f-5d0f-48bcc8899524_thumb.png"},
        {"author_id" => 3,"cover_img_uuid" => "2af1dff0-5400-012f-5d0f-48bcc8899524","created_at" => "2012-03-19T14:45:49Z","edition" => "","file_content_type" => "application/pdf","file_file_name" => "5things_presentation_102811.pdf","file_file_size" => 2723092,"file_updated_at" => "2012-03-19T14:45:49Z","id" => 66,"index_erro" => nil,"publisher" => "","title" => "teste","updated_at" => "2012-03-24T09:59:45Z","user_id" => 1,"year" => 2003,"thumb_image_path" => "/images/covers/cover_2af1dff0-5400-012f-5d0f-48bcc8899524_thumb.png"},                                        
        {"author_id" => 3,"cover_img_uuid" => "2af1dff0-5400-012f-5d0f-48bcc8899524","created_at" => "2012-03-19T14:45:49Z","edition" => "","file_content_type" => "application/pdf","file_file_name" => "5things_presentation_102811.pdf","file_file_size" => 2723092,"file_updated_at" => "2012-03-19T14:45:49Z","id" => 67,"index_erro" => nil,"publisher" => "","title" => "teste","updated_at" => "2012-03-24T09:59:45Z","user_id" => 1,"year" => 2003,"thumb_image_path" => "/images/covers/cover_2af1dff0-5400-012f-5d0f-48bcc8899524_thumb.png"}
      ]}
    
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
  
end
