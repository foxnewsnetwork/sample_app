require 'spec_helper'
require 'factories'

describe MacropostsController do
    render_views
    
    describe "access control" do
      
      describe "failure for non-signed-in users" do
        
        it "should deny access to create" do
          post :create
          response.should redirect_to(signin_path)
        end
        
        it "should deny access to destroy" do
          delete :destroy, :id => 1
          response.should redirect_to(signin_path)
        end
      end
      
    end
    
    describe "DELETE 'destroy'" do
      
      describe "for an unauthorized user" do
        
        before(:each) do
          @user = Factory(:user)
          wrong_user = Factory(:user, :email => Factory.next(:email))
          test_sign_in(wrong_user)
          @macropost = Factory(:macropost, :user => @user)
        end
        
        it "should deny access" do
          delete :destroy, :id => @macropost
          response.should redirect_to(root_path)
        end
      end
      
      describe "for an authorized user" do
        
        before(:each) do
          @user2 = test_sign_in(Factory(:user))
          @macropost = Factory(:macropost, :user => @user2)
        end
        
        it "should destroy the macroposts" do
          lambda do
            delete :destroy, :id => @macropost.id
          end.should change(Macropost, :count).by(-1)
        end
      end
    end
    
    describe "POST 'create'" do
    
      before(:each) do
        @user = test_sign_in(Factory(:user))
      end
      
      describe "failure cases" do
        
        before(:each) do
          @attr = { :content => '' , :title => '', :location_id => 1 }
        end
        
        it "should not create a macropost" do
          lambda do
            post :create, :macropost => @attr
          end.should_not change(Macropost, :count)
        end
        
        it "should render the home page" do
          post :create, :macropost => @attr
          response.should redirect_to('pages/home')
        end
        
        
      end
      
      describe "success cases" do
        
        before(:each) do
          @attr = { 
                  :content => 'lorem ipsum' ,
                  :title => 'title here' ,
                  :location_id => 1
                  }
        end
        
        it "should create a macropost" do
          lambda do
            post :create, :macropost => @attr
          end.should change(Macropost, :count).by(1)
        end
        
        it "should redirect to the home page" do
          post :create, :macropost => @attr
          response.should redirect_to(root_path) 
        end
        
        it "should display the correct flash message" do
          post :create, :macropost => @attr
          flash[:success].should =~ /created/i
        end
        
      end
      
    end
end
