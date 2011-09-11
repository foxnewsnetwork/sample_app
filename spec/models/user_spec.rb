require 'spec_helper'

describe User do
  
  before(:each) do
    @attr = { :username => 'lolcat' , :email => 'lolcat@lol.cat' }
  end
  
  it "should create a new instance given valid attributes" do
    temp = User.new(@attr)
  end
  
  it "should require a name" do
    lolcat = User.new(@attr.merge( :username => '' ) )
    lolcat.should_not be_valid
  end
  
  it "should require an email address" do
    lolcat = User.new(@attr.merge( :email => '' ) )
    lolcat.valid?.should == false
  end
  
  it "should not have usernames that are too long" do
    lolcat = User.new( @attr )
    lolcat.username = "a"*65
    lolcat.should_not be_valid
  end
  
  it "should contain a valid email address" do
    lolcat = User.new( @attr.merge( :email => 'dickface' ) )
    lolcat.should_not be_valid
  end
  
  it "should not have duplicate email address" do
    User.create!(@attr)
    lolcat = User.new(@attr)
    lolcat.should_not be_valid
  end
  
  it "should reject email address that only differ by case" do
    upcased_email = @attr[:email].upcase
    lolcat = User.new( @attr )
    User.create!( @attr.merge(:email => upcased_email) )
    lolcat.should_not be_valid
  end
end
