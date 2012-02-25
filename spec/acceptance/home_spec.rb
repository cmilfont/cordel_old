# encoding: UTF-8
require 'spec_helper'

describe "Home" do
  
  context "Quando deslogado" do
    it "Deveria ver os ultimos livros cadatrados LAST ADDED BOOKS"
    it "Deveria ver com mais leitores TOP RATED"
    it "Deveria ver Login via facebook, twitter ou sign up"
  end
  
  context "Quando logado" do
    it "Deveria ver meus livros"
  end
  
  context "Busca" do
    
    describe "Busca simples" do
      it "Deveria listar livros com base em busca textual"
    end
    
    describe "Busca Avançada" do
      it "Deveria pesquisar com busca textual, author, editora ou ISBN"
    end
    
  end
  
end