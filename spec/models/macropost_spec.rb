require 'spec_helper'
require 'factories'

describe Macropost do
  before(:each) do
    @user = Factory(:user)
    @attr = { :content => "value for content" , 
              :title => "value for title" ,
              :location_id => 1 
            }
  end
  
  it "should create a new instance given valid attributes" do
    @user.macroposts.create!(@attr)
  end
  
  describe "user associations" do
    before(:each) do
      @macropost = @user.macroposts.create(@attr)
    end
    
    it "should have a user attribute" do
      @macropost.should respond_to(:user)
    end
    
    it "should have the right associated user" do
      @macropost.user_id.should == @user.id
      @macropost.user.should == @user
    end
  end
  
  describe "validations" do
    
    it "should require a user id" do
      Macropost.new(@attr).should_not be_valid
    end
    
    it "should require nonblank content" do
      @user.macroposts.build(@attr.merge(:content => '')).should_not be_valid
    end
    
    it "should require nonblank title" do
      @user.macroposts.build(@attr.merge( :title => '')).should_not be_valid
    end
    
    it "should require a nonzero location id" do
      @user.macroposts.build(@attr.merge(:location_id => '')).should_not be_valid 
    end
    
    
  end
end
