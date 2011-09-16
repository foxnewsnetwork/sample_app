require 'spec_helper'
require 'factories'

describe UsersController do
  render_views
  
  before( :each ) do
    @base_title = "CoTABit "
  end
  
  describe "PUT 'update'" do
    
    before(:each) do
      @user = Factory(:user)
      test_sign_in(@user)
    end
    
    describe "failure" do
      
      before(:each) do
        @attr = { :email => "" , :username => "" , :password => "" , 
        :password_confirmation => "" }
      end
      
      it "should render the 'edit' page" do
        put :update, :id => @user.id, :user => @attr
        response.should render_template('edit')
      end
      
      it "should have the right title" do
        put :update, :id => @user.id, :user => @attr
        response.should have_selector("title", :content => 'Edit user')
      end
    end
    
    describe "success" do
      
      before(:each) do
        @attr = { :username => "new name" , :email => "user@example.org" ,
        :password => "boobs" , :password_confirmation => "boobs" }
      end
      
      it "should change the user's attributes" do
        put :update, :id => @user.id, :user => @attr
        @user.reload
        @user.username.should == @attr[:username]
        @user.email.should == @attr[:email]
      end
      
      it "should redirect to the user show page" do
        put :update, :id => @user.id, :user => @attr
        response.should redirect_to(user_path(@user))
      end
      
      it "should have a flash message" do
        put :update, :id => @user.id , :user => @attr
        flash[:success].should =~ /updated/i
      end
    end
  end
  
  describe "GET 'edit'" do
  
    before(:each) do
      @user = Factory(:user)
      test_sign_in(@user)
    end
    
    it "should be successful" do
      get :edit, :id => @user.id
      response.should be_success
    end
    
    it "should have the right title" do
      get :edit, :id => @user.id
      response.should have_selector("title" , :content => "Edit user")
    end
    
    it "should have a link to change the Gravatar" do
      get :edit, :id => @user
      gravatar_url = "http://gravatar.com/emails"
      response.should have_selector('a' , :href => gravatar_url , 
                                          :content => "change")
    end
  end

  describe "GET 'new'" do
  
    it "should be successful" do
      get 'new'
      response.should be_success
    end
    
    it "should have the username field" do
      get 'new'
      response.should have_selector( "input[name='user[username]'][type='text']" )
    end
    
    it "should have the email field" do
      get 'new'
      response.should have_selector("input[name='user[email]'][type='text']")
    end
    
    it "should have the password field" do
      get 'new'
      response.should have_selector( "input[name='user[password]'][type='password']")
    end
    
    it "should have the confirmation field" do
      get 'new'
      response.should have_selector("input[name='user[password_confirmation]'][type='password']")
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
        
        it "should sign a user in" do
          post :create, :user => @attr3
          controller.should be_signed_in
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
