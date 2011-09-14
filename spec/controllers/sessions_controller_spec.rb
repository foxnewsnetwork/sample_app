require 'spec_helper'
require 'factories'

describe SessionsController do
  render_views
  
  describe "DELETE 'destroy'" do
  
    it "should sign a user out" do
      test_sign_in(Factory(:user))
      delete :destroy
      controller.should_not be_signed_in
      response.should redirect_to(root_path)
    end
  
  end
  
  describe "POST 'create'" do
  
    describe "invalid login" do
    
      before(:each) do
        @attr = { :email => 'e@ex.com', :password => 'invalid' }
      end
      
      it "should re-render the new page" do
        post :create, :sessions => @attr
        response.should render_template('new')
      end
      
      it "should have the right title" do
        post :create, :sessions => @attr
        response.should have_selector("title", :content => "Sign in")
      end
      
      it "should have a flash.now message" do
        post :create, :sessions => @attr
        flash.now[:error].should =~ /invalid/i
      end
      
    end
    
    describe "valid login" do
    
      before(:each) do
        @user = Factory(:user)
        @attr = { :email => @user.email , :password => @user.password }
      end
      
      it "should sign the user in" do
        post :create, :sessions => @attr
        controller.current_user.should == @user
        controller.should be_signed_in
      end
      
      it "should redirect to the user show page" do
        post :create , :sessions => @attr
        response.should redirect_to(user_path(@user))
      end
    
    end
  end
  
  describe "GET 'new'" do
    it "should be successful" do
      get 'new'
      response.should be_success
    end
    
    it "should have the correct title" do
      get 'new'
      response.should have_selector( "title" , :content => 'Sign in' )
    end
  end

end
