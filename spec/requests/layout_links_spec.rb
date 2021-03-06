require 'spec_helper'

describe "LayoutLinks" do
  describe "GET 'home'" do
    it "should be successful" do
      get '/'
      response.should be_success
    end
  end
  
  describe "GET 'contact'" do
    it "should be successful" do
      get '/contact'
      response.should be_success
    end
  end
  
  describe "GET 'about'" do
    it "should be successful" do
      get '/about'
      response.should be_success
    end
  end
  
  describe "GET 'help'" do
    it "should be successful" do
      get '/help'
      response.should be_success
    end
  end
end
