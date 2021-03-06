require 'spec_helper'

describe UsersController do
  render_views

  describe "GET 'new'" do
    it "should be successful" do
      get 'new'
      response.should be_success
    end
  end
  
  describe "GET 'show'" do
    before(:each) do 
      @user = Factory(:user)
    end
      
    it "should be successful" do 
      get :show, :id => @user 
      response.should be_success
    end
    
    it "should find the right user" do 
      get :show, :id => @user 
      assigns(:user).should == @user
    end 
  end
  
  describe "POST 'create'" do
    describe "failure" do
      before(:each) do 
        @attr = { :name => "", 
                  :email => "", 
                  :password => "",
                  :password_confirmation => "" }
      end
      
      it "should not create a user" do 
        lambda do
          post :create, :user => @attr 
        end.should_not change(User, :count)
      end
      
      it "should render the 'new' page" do
        post :create, :user => @attr 
        response.should render_template('new')
      end
    end
    
    describe "success" do
      before(:each) do 
        @attr = { :name => "New User", 
                  :email => "user@example.com",
                  :password => "foobar", 
                  :password_confirmation => "foobar" }
      end
    
      it "should create a user" do 
        lambda do
          post :create, :user => @attr 
        end.should change(User, :count).by(1)
      end
      
      it "should sign the user in" do
        post :create, :user => @attr
        controller.should be_signed_in 
      end
      
      it "should redirect to the user show page" do 
        post :create, :user => @attr 
        response.should redirect_to(user_path(assigns(:user)))
      end
      
      it "should have a welcome message" do
        post :create, :user => @attr
        flash[:success].should =~ /Congratulations, and thanks for signing up!/
      end
    end
  end          
  
  describe "GET 'edit'" do
    before(:each) do 
      @user = Factory(:user) 
      test_sign_in(@user)
    end
    
    it "should be successful" do 
      get :edit, :id => @user 
      response.should be_success
    end
  end

  describe "PUT 'update'" do
    before(:each) do 
      @user = Factory(:user) 
      test_sign_in(@user)
    end 
    
    describe "failure" do
      before(:each) do 
        @attr = { :email => "", 
                  :name => "", 
                  :password => "",
                  :password_confirmation => "" }
      end
      
      it "should render the 'edit' page" do 
        put :update, :id => @user, 
                     :user => @invalid_attr 
        response.should render_template('edit')
      end
    end
    
    describe "success" do
      before(:each) do 
        @attr = { :name => "New Name", 
                  :email => "user@example.org",
                  :password => "barbaz", 
                  :password_confirmation => "barbaz" }
      end
      
      it "should change the user's attributes" do 
        put :update, :id => @user, 
                     :user => @attr 
        user = assigns(:user) 
        @user.reload
        @user.name.should == user.name
        @user.email.should == user.email
      end
      
      it "should redirect to the user show page" do 
        put :update, :id => @user, 
                     :user => @attr 
        response.should redirect_to(user_path(@user))
      end
      
      it "should have a flash message" do 
        put :update, :id => @user, 
                      :user => @attr 
        flash[:success].should =~ /updated/
      end
    end
  end

  describe "authentication of edit/update pages" do
    before(:each) do 
      @user = Factory(:user)
    end 
    
    describe "for non-signed-in users" do
      it "should deny access to 'edit'" do 
        get :edit, :id => @user 
        response.should redirect_to(login_path)
      end
      
      it "should deny access to 'update'" do 
        put :update, :id => @user, :user => {} 
        response.should redirect_to(login_path)
      end 
    end
  end
  
  describe "GET 'index'" do
    describe "for non-signed-in users" do 
      it "should deny access" do
        get :index 
        response.should redirect_to(login_path) 
        flash[:notice].should =~ /sign in/
      end 
    end
    
    describe "for signed-in users" do
      before(:each) do 
        @user = test_sign_in(Factory(:user)) 
        second = Factory(:user, :email => "another@example.com") 
        third = Factory(:user, :email => "another@example.net")
        @users = [@user, second, third] 
        30.times do
          @users << Factory(:user, :email => Factory.next(:email)) 
        end
      end
      
      it "should be successful" do 
        get :index 
        response.should be_success
      end
    end
  end
  
  describe "DELETE 'destroy'" do
    before(:each) do 
      @user = Factory(:user)
    end
    
    describe "as a non-signed-in user" do 
      it "should deny access" do
        delete :destroy, :id => @user
        response.should redirect_to(root_path) 
      end
    end
  
    describe "as a non-admin user" do 
      it "should protect the page" do
        test_sign_in(@user) 
        delete :destroy, :id => @user 
        response.should redirect_to(root_path)
      end 
    end
    
    describe "as an admin user" do
      before(:each) do 
        admin = Factory(:user, 
                        :email => "admin@example.com", 
                        :admin => true) 
        test_sign_in(admin)
      end
      
      it "should destroy the user" do 
        lambda do
          delete :destroy, :id => @user 
        end.should change(User, :count).by(-1)
      end
  
      it "should redirect to the users page" do 
        delete :destroy, :id => @user 
        response.should redirect_to(users_path)
      end
    end
  end
  
  describe "GET 'show'" do
    before(:each) do 
      @user = Factory(:user)
    end
    
    it "should show the user's recipes" do
      recipe1 = Factory(:recipe, :user => @user, :instructions => "Stir it") 
      recipe2 = Factory(:recipe, :user => @user, :instructions => "Sear it") 
      get :show, :id => @user 
      response.should be_success
    end
  end
end
