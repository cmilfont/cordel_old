class BookMailer < ActionMailer::Base
  
  def recomendar email, book
    @book = book
    mail(:from => "cmilfont@gmail.com",
         :to => email,
         :subject => "Recomendacao de livro").deliver
  end
  
end