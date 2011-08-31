require 'spec_helper'

describe "LayoutLinks" do
  describe "GET /layout_links" do
    it "works! (now write some real specs)" do
      get layout_links_path
    end
  end
  
  it "should have a home page at '/'" do
    get '/contact'
    response.should have_selector( 'title' , :content => 'Contact' )
  end
  
  it "should have an about page at '/about'" do
    get '/about'
    response.should have_selector( 'title' , :content => 'About' )
  end
  
  it "should have a help page at '/help'" do
    get '/help'
    response.should have_selector( 'title' , :content => 'Help' )
  end
  
  it "should have a contact page at '/contact'" do
    get '/contact'
    response.should have_selector( 'title' , :content => 'Contact' )
end
