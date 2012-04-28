class Book < ActiveRecord::Base
  
#  attr_accessible :thumb_image_path
  
  belongs_to :user
  validates_presence_of :user
  
  belongs_to :author
  accepts_nested_attributes_for :author
  validates_presence_of :author

  has_many :pages, :dependent => :destroy  
  
  has_attached_file :file
  validates_attachment_presence :file
  validates_attachment_size :file, :less_than => 20.megabytes
  validates_attachment_content_type :file, :content_type => ['application/pdf']
  
  attr_accessor :author_highlighted, :pages_content_highlighted, :title_highlighted, :publisher_highlighted
  searchable do
    text :author, :stored => true do
      author.try(:name)
    end
    text :title, :stored => true
    text :edition
    text :publisher, :stored => true
    text :year
    text :pages_content, :stored => true do
      pages.map do |page|
        page.content
      end
    end
    integer :user_id
  end
  
  @queue = :file_serve
  def process(book_id)
    book = Book.find(book_id)
    
    #url = Rails.root.to_s + "/public" + Book.find(66).file.url(:original, :timestamp => false)
    url = Rails.root.to_s + "/public" + "/system/files/66/original/crafting-rails-applications_p1_0.pdf"
    PDF::Reader.open(url) do |reader|
      puts reader.info.inspect
      
      info = reader.info
      puts "Title => " + info[:Title]
      puts "Author => " + info[:Author]
      
    end

    url = Rails.root.to_s + "/public" + book.file.url(:original, :timestamp => false)
  	receiver = PageTextReceiver.new
    pdf = PDF::Reader.file(url, receiver)
    page_number = 0
    book.pages = []
    receiver.content.each{|page|      
      page_number += 1
      book.pages << Page.new(:content => page, :page_number => page_number)
    }
    book.save
    Sunspot.index! book.pages
  rescue Exception => e
    book.index_erro = e.message
    book.save
  end
  
  def self.mybooks(user)
    where(:user_id => user.id)
  end

  def large_image_path
    if cover_img_uuid
      Book.cover_dir + "/cover_#{cover_img_uuid}_large.png"
    else
      "cover_large.png"
    end
  end

  def small_image_path
    if cover_img_uuid
      Book.cover_dir + "/cover_#{cover_img_uuid}_small.png"
    else
      "cover_small.png"
    end
  end

  def thumb_image_path
    if cover_img_uuid
      Book.cover_dir + "/cover_#{cover_img_uuid}_thumb.png"
    else
      "cover_thumb.png"
    end
  end


  def file_full_path
    Rails.root.to_s + "/public" + file.url(:original, :timestamp => false)
  end

  def self.cover_dir
     return "/images/covers"
  end

  def self.full_cover_dir
    return Rails.root.to_s + "/public"+ cover_dir
  end

  def self.recent_books
    return Book.find(:all, :order => "created_at DESC LIMIT 8")
  end

  def self.top_rated_books
    return Book.find(:all, :order => "rating_average DESC LIMIT 12")
  end

  class << self

    def queue
      @queue
    end

    def queue=( new_queue )
      @queue = new_queue
    end

    def deliver(id)
      Resque.enqueue(GenerateBookCover, id)
      Resque.enqueue(Book, id)
    end

    def perform(id)
      new().process(id)
    end

  end
  
  
end
