require 'spec_helper'
require 'factories'

describe "Users" do

  describe "GET /users" do
  
    describe "sign in/out" do
    
      describe "failure" do
        it "should not sign a user in" do
          visit signin_path
          fill_in :email, :with => ''
          fill_in :password, :with => ''
          click_button
          response.should have_selector("div.flash.error", :content => "Invalid")
        end
      end
      
      describe "success" do
        it "should sign a user in and out" do
          user = Factory(:user)
          visit signin_path
          fill_in :email, :with => user.email
          fill_in :password, :with => user.password
          click_button
          controller.should be_signed_in
          click_link "Sign out"
          controller.should_not be_signed_in
        end
      end        
    end
    
    describe "signup" do
      
      describe "failure" do
        
        it "should not make a new user" do
          lambda do
            visit signup_path
            fill_in "Username" , :with => ''
            fill_in "Email" , :with => ''
            fill_in "Password" , :with => ''
            fill_in "Confirmation" , :with => ''
            click_button
            response.should render_template('users/new')
            response.should have_selector( "div#error_explanation" )
          end.should_not change( User, :count )
        end
        
        it "should clear the password fields after a fail attempt" do
          visit signup_path
          fill_in "Username" , :with => ''
          fill_in "Email" , :with => ''
          fill_in "Password" , :with => 'shouldbegone'
          fill_in "Confirmation" , :with => 'shouldbegone'
          click_button
          response.should render_template( 'users/new' )
          response.should have_selector("input[name='user[password]'][type='password']" , 
                                        :value => '')
        end
        
        it "should clear the confirmation field after a fail attempt" do
          visit signup_path
          fill_in "Username" , :with => ''
          fill_in "Email" , :with => ''
          fill_in "Password" , :with => 'shouldbegone'
          fill_in "Confirmation" , :with => 'shouldbegone'
          click_button
          response.should render_template( 'users/new' )
          response.should have_selector("input[name='user[password_confirmation]'][type='password']" , :value => '')
        end
        
        
      end
      
      describe "success" do
        
        it "should make a new user" do
          lambda do
            visit signup_path
            fill_in "Username" , :with => 'example user'
            fill_in "Email" , :with => 'user@example.com'
            fill_in "Password" , :with => '1234567'
            fill_in "Confirmation" , :with => '1234567'
            click_button
            response.should have_selector( "div.flash.success" , :content => "Welcome" )
            response.should render_template("users/show")
          end.should change( User, :count).by(1)
        end
      end
    end
  end
end
