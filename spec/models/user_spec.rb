require 'spec_helper'

describe User do
  before(:each) do 
    @attr = { :name => "Example User", 
              :email => "user@example.com",
              :password => "foo123!",
              :password_confirmation => "foo123!"
            }
  end
  
  it "should create a new instance given valid attributes" do 
    User.create!(@attr)
  end
  
  it "should require a name" do
    @attr[:name] = ""
    bad = User.new(@attr)
    bad.should_not be_valid
  end
  
  it "should require an email" do
    @attr[:email] = ""
    bad = User.new(@attr)
    bad.should_not be_valid
  end
  
  it "should fail excessively long names" do
    @attr[:name] = "foo" * 30
    bad = User.new(@attr)
    bad.should_not be_valid
  end
  
  it "should fail duplicate email addresses" do
    User.create!(@attr)
    second = User.new(@attr)
    second.should_not be_valid
  end
  
  describe "password-related tests" do
  
    it "should require a password" do 
      foo = User.new(@attr.merge(:password => "", :password_confirmation => ""))
      foo.should_not be_valid
    end
    
    it "should require a matching password confirmation" do
      foo = User.new(@attr.merge(:password_confirmation => "invalid"))
      foo.should_not be_valid
    end
  
    it "should reject short passwords" do 
      short = "a" * 5 
      hash = @attr.merge(:password => short, :password_confirmation => short)   
      User.new(hash).should_not be_valid
    end
    
    it "should reject long passwords" do 
      long = "a" * 41
      hash = @attr.merge(:password => long, :password_confirmation => long)
      User.new(hash).should_not be_valid 
    end
    
    it "should have an encrypted password attribute" do 
      user = User.create!(@attr)
      user.should respond_to(:encrypted_password)
    end
    
    it "should set the encrypted password" do
      user = User.create!(@attr)
      user.encrypted_password.should_not be_blank 
    end
    
    it "should be true if the passwords match" do
      user = User.create!(@attr)
      user.has_password?(@attr[:password]).should be_true
    end
    
    it "should be false if the passwords don't match" do
      user = User.create!(@attr)
      user.has_password?("invalid").should be_false
    end
  end
  
  describe "authentication tests" do
  
    before(:each) do
      @user = User.create!(@attr)
    end
      
    it "should return nil on email/password mismatch" do 
      wrong_password_user = User.authenticate(@attr[:email], "wrongpass")
      wrong_password_user.should be_nil
    end
    
    it "should return nil for an email address with no user" do 
      nonexistent_user = User.authenticate("bar@foo.com", @attr[:password])
      nonexistent_user.should be_nil
    end
    
    it "should return the user on email/password match" do 
      matching_user = User.authenticate(@attr[:email], @attr[:password])
      matching_user.should == @user
    end
  
  end
  
  describe "admin attribute" do
    before(:each) do 
      @user = User.create!(@attr)
    end

    it "should respond to admin" do 
      @user.should respond_to(:admin)
    end

    it "should not be an admin by default" do 
      @user.should_not be_admin
    end
  
    it "should be convertible to an admin" do 
      @user.toggle!(:admin) 
      @user.should be_admin
    end 
  end
  
  describe "has recipes" do
    before(:each) do
      @user = User.create(@attr)
      @recipe1 = Factory(:recipe, :user => @user, :created_at => 2.hours.ago)
      @recipe2 = Factory(:recipe, :user => @user, :created_at => 4.days.ago)
    end
    
    it "should have a recipe" do
      @user.should respond_to(:recipes)
    end
    
    it "should have the recipes in reverse cronological order" do
      #TODO Break this to provide a known bug - where recipes don't show in order
      @user.recipes.should == [@recipe1, @recipe2]
    end
    
    it "should destroy user's recipe" do
      @user.destroy
      [@recipe1, @recipe2].each do |recipe|
        Recipe.find_by_id(recipe.id).should be_nil
      end
    end
    
    describe "status recipebox" do
      it "should have a recipebox" do
        @user.should respond_to(:recipebox)
      end
      
      it "should include the user's recipes" do
        @user.recipebox.include?(@recipe1).should be_true
        @user.recipebox.include?(@recipe2).should be_true
      end
      
      it "should not include a different user's recipes" do
        recipe3 = Factory(:recipe, :user => 
                          Factory(:user, :email => Factory.next(:email)))
        @user.recipebox.include?(recipe3).should be_false
      end
      
      
    end
  end
  
end
