require 'spec_helper'

describe Recipe do

  before(:each) do
    @user = Factory(:user)
    @attr = { :instructions => "Mix it up and bake at 450" } 
  end

  it "should create a new instance given valid attributes" do   
    @user.recipes.create!(@attr)
  end 
  
  describe "user associations" do
    before(:each) do
      @recipe = @user.recipes.create(@attr)
    end
    
    it "should have a user attribute" do
      @recipe.should respond_to(:user)
    end
    
    it "should have the right user" do
      @recipe.user_id.should == @user.id
      @recipe.user.should == @user
    end
  
  end
  
  describe "valid attributes" do
    it "should require a user id" do
      Recipe.new(@attr).should_not be_valid
    end
    
    it "should require instructions" do
      @user.recipes.build(:instructions => " ").should_not be_valid
    end
      
    it "should reject overly long instructions" do
      @user.recipes.build(:instructions => "b" * 257).should_not be_valid
    end
  end
end
