require 'spec_helper'
require 'factories'

describe UsersController do
  render_views
  
  before( :each ) do
    @base_title = "CoTABit "
  end

  describe "GET 'new'" do
    it "should be successful" do
      get 'new'
      response.should be_success
    end
    
    it "should have the right title" do
      get 'new'
      response.should have_selector( "title" , :content => @base_title + "| Sign up" )
    end
  end
  
  describe "GET 'show'" do
  
    before(:each) do
      @user = Factory(:user)
    end
    
    it "should be successful" do
      get :show, :id => @user.id
      response.should be_success
    end
    
    it "should be successful" do
      get :show, :id => @user.id
      assigns(:user).should == @user
    end
    
    it "should have the right title" do
      get :show, :id => @user.id
      response.should have_selector( "title" , :content => @user.username )
    end
    
    it "should include the user's name in heading" do
      get :show, :id => @user.id
      response.should have_selector( "h1" , :content => @user.username )
    end
    
    it "should have a profile image" do
      get :show, :id => @user.id
      response.should have_selector( "h1>img" , :class => "gravatar" )
    end
  end
end
