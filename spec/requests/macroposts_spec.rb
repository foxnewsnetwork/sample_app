require 'spec_helper'
require 'factories'

describe "Macroposts" do

  before(:each) do
    user = Factory(:user)
    visit signin_path
    fill_in :email, :with => user.email
    fill_in :password, :with => user.password
    click_button
  end
  
  describe "creation" do
    
    describe "failure" do
      
      it "should not make a new macropost" do
        lambda do
          visit root_path
          fill_in :macropost_content, :with => ""
          click_button
          response.should redirect_to("pages/home")
          flash[:error] =~ /fail/i
        end.should_not change(Macropost, :count)
      end
      
    end
    
    describe "success" do
      
      it "should make a new macropost" do
        title = "new shit"
        content = "this is content"
        lambda do
          visit root_path
          fill_in :macropost_title, :with => title
          fill_in :macropost_content, :with => content
          click_button
        end.should change(Macropost, :count).by(1)
      end
    end
  end
end
