require 'spec_helper'

describe User do
  before(:each) do 
    @attr = { :name => "Example User", :email => "user@example.com" }
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
end
