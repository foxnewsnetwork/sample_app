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
    
    describe "Post 'create'" do
      
      describe "failure" do
        
        before(:each) do
          @attr2 = { :name => '' , :email => '' ,
                     :password => '' , :password_confirmation => '' }
        end
        
        it "should not create an user" do
          lambda do
            post :create, :user => @attr2
          end.should_not change(User, :count)
        end
        
        it "should have the right title" do
          post :create, :user => @attr2
          response.should have_selector( "title" , :content => "Sign up" )
        end
        
        it "should render the 'new' page" do
          post :create, :user => @attr2
          response.should render_template('new')
        end
        
      end
      
      describe "success" do
        
        before(:each) do
          @attr3 = { 
                    :username => 'New User' ,
                    :email => 'user@example.com' ,
                    :password => 'validpassword' ,
                    :password_confirmation => 'validpassword' 
                    }
        end
        
        it "should create a user" do
          lambda do
            post :create , :user => @attr3
          end.should change(User, :count).by(1)
        end
        
        it "should redirect to the user show page" do
          post :create , :user => @attr3
          response.should redirect_to(user_path(assigns(:user)))
        end
        
        it "should have a welcome message" do
          post :create , :user => @attr3
          flash[:success].should =~ /welcome/i
        end
      end
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
