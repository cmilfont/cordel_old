# -*- coding: utf-8 -*-
class GenerateBookCover
  include Magick
  @queue = :generate_book_cover
  
  def self.perform(book_id)
    book = Book.find(book_id)
    pdf = ImageList.new(book.file_full_path + "[0]")
    uuid = UUID.new.generate
    pdf.write( Book.full_cover_dir + "/cover_#{uuid}_large.png")
    image_small = pdf.scale(200,300)
    image_thumb = pdf.scale(80,120)
    # image_thumb = pdf.scale(40,70)
    image_small.write( Book.full_cover_dir + "/cover_#{uuid}_small.png")
    image_thumb.write( Book.full_cover_dir + "/cover_#{uuid}_thumb.png")
    
    book.cover_img_uuid = uuid
    book.save
  end
  
end
