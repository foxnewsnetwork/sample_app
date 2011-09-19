require 'spec_helper'
require 'factories'

describe UsersController do
  render_views
  
  before( :each ) do
    @base_title = "CoTABit "
  end
  
  describe "DELETE 'destroy'" do
    
    before(:each) do
      @user = Factory(:user)
    end
    
    describe "as a non-signed-in user" do
      
      it "should protect the page" do
        delete :destroy, :id => @user
        response.should redirect_to(signin_path)
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
        @admin = Factory(:user, :email => "admin@admin.admin")
        @admin.toggle(:admin)
        test_sign_in(@admin)
      end
      
      it "should destroy the user" do
        lambda do
          delete :destroy, :id => @user
        end.should change(User, :count).by(-1)
      end
      
      it "should let not admins destroy themselves" do
        lambda do
          delete :destroy , :id => @admin
        end.should_not change(User, :count)
        
      end
      
      it "should give admins a nice warning if they try to delete themselves" do
        delete :destroy, :id => @admin
        response.should redirect_to(users_path)
        flash[:error].should =~ /cannot delete/i
      end
      
      it "should redirect to the users page" do
        delete :destroy, :id => @user
        response.should redirect_to(users_path)
      end
    end
  end
  
  describe "GET 'index'" do
    
    describe "for non-signed-in-users" do
    
      it "should deny access" do
        get :index
        response.should redirect_to(signin_path)
        flash[:notice].should =~ /sign in/i
      end
    
    end
    
    describe "for signed-in users" do
      
      before(:each) do
        @user = test_sign_in(Factory(:user))
        second = Factory(:user, :username => "bob", :email => "c@d.com")
        third = Factory(:user, :username => "ben", :email => "e@f.com")
        @users = [@user , second , third]
        
        30.times do |n|
          @users << Factory(:user, :email => Factory.next(:email))
        end
      end
      
      it "should be successful" do
        get :index
        response.should be_success
      end
      
      it "should not have those links to delete other users" do
        get :index
        response.should_not have_selector("a" , :title => "delete")
      end
      
      it "should have the right title" do
        get :index
        response.should have_selector("title", :content => "All users")
      end
      
      it "should have an element for each user" do
        get :index
        @users[0..2].each do |user|
          response.should have_selector("li", :content => user.username)
        end
      end
      
      it "should paginate users" do
        get :index
        response.should have_selector("div.pagination")
        response.should have_selector("span.disabled", :content => "Previous")
        response.should have_selector("a" , :href => "/users?page=2" ,
                                            :content => "2")
        response.should have_selector("a" , :href => "/users?page=2" ,
                                            :content => "Next")
      end
      
    end
  end
  
  describe "authentication of edit/update pages" do
    
    before(:each) do
      @user = Factory(:user)
    end
    
    describe "for non-signed-in-users" do
    
      it "should deny access to 'edit'" do
        get :edit , :id => @user.id
        response.should redirect_to(signin_path)
      end
      
      it "should deny access to 'update'" do
        get :update, :id => @user.id, :user => {}
        response.should redirect_to(signin_path)
      end
      
    end
    
    describe "for signed in users" do
    
      before(:each) do
        wrong_user = Factory(:user , :email => "user@example.net")
        test_sign_in(wrong_user)
      end
      
      it "should require matching user for 'edit'" do
        get :edit , :id => @user.id
        response.should redirect_to(root_path)
      end
      
      it "should require matching users for update" do
        put :update , :id => @user.id , :user => { }
        response.should redirect_to(root_path)
      end
    
    end
    
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
        @attr = { :username => "new name" , :email => "user@eo.org" ,
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
                    :email => 'user@exame.com' ,
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
    
    it "should show the user's macroposts" do
      mp1 = Factory(:macropost, :user => @user, 
                    :content => "foobar" ,
                    :title => "titbar" ,
                    :location_id => 0 )
      mp2 = Factory(:macropost, :user => @user, 
                    :content => "2 foobar" ,
                    :title => "titbar" ,
                    :location_id => 0 )
      get :show, :id => @user.id
      response.should have_selector("span.content", :content => mp1.content)
      response.should have_selector("span.content", :content => mp2.content)
      response.should have_selector("span.title", :content => mp1.title)
      response.should have_selector("span.title", :content => mp2.title)
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
