require 'spec_helper'

describe RecipesController do
  render_views

  describe "access control" do
    it "should deny access to 'create'" do 
      post :create 
      response.should redirect_to(login_path)
    end
  end

  describe "POST 'create'" do
    before(:each) do 
      @user = test_sign_in(Factory(:user))
    end 
    
    describe "success" do
      before(:each) do 
        @attr = { :user => @user, :instructions => "Bake it" }
      end
    
      it "should create a recipe" do 
        lambda do
          post :create, :recipe => @attr 
        end.should change(Recipe, :count).by(1)
      end
  
      it "should redirect to the home page" do 
        post :create, :recipe => @attr 
        response.should redirect_to(root_path)
      end
  
      it "should have a flash message" do 
        post :create, :recipe => @attr 
        flash[:success].should =~ /Now we're cooking!/
      end
    end
    
    
    describe "failure" do
      before(:each) do 
        @attr = { :user => @user, :insructions => "" }
      end
      
      it "should not create a recipe" do 
        lambda do
          post :create, :recipe => @attr 
        end.should_not change(Recipe, :count)
      end

      it "should render the home page" do 
        post :create, :recipe => @attr 
        response.should render_template('pages/home')
      end
    end
  end
  
end