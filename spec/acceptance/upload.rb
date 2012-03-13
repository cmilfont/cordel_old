# encoding: UTF-8
require 'spec_helper'

describe "Upload do livro" do

  before do
    visit upload_path
    fill_in "Title",  :with => "Domain Driven Design"
    fill_in "Author", :with => "Eric Evans"
    attach_file('File', '/path/to/ddd.pdf')
  end
    
  describe "Quando submeter um ebook" do
    it "Deveria verificar o livro salvo"
    it "Deveria verificar se o livro link para páginas"
    it "Deveria informar a quantidade de páginas, author e title"
  end

end