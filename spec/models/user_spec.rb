require 'spec_helper'
require 'factories'

describe User do
  
  before(:each) do
    @attr = { :username => 'lolcat' , 
              :email => 'lolcat@lol.cat' ,
              :password => 'jackass' ,
              :password_confirmation => 'jackass' 
            }
  end
  
    
  
  describe "macropost associations" do
    before(:each) do
      @user = User.create(@attr)
      @mp1 = Factory(:macropost, :user => @user, :created_at => 1.day.ago)
      @mp2 = Factory(:macropost, :user => @user, :created_at => 1.hour.ago)
    end
    
    describe "status feed" do
      
      it "should have a feed" do
        @user.should respond_to(:feed)
      end
      
      it "should include the user's macroposts" do
        @user.feed.include?(@mp1).should be_true
        @user.feed.include?(@mp2).should be_true
      end
      
      it "should not include a different user's macroposts" do
        mp3 = Factory(:macropost, :user => Factory(:user, :email => Factory.next(:email)))
        @user.feed.include?(mp3).should be_false
      end
    end
    
    it "should destroy associated macroposts" do
      @user.destroy
      [@mp1, @mp2].each do | u |
        Macropost.find_by_id(u.id).should be_nil
      end
    end
    it "should havce a macroposts attribute" do
      @user.should respond_to(:macroposts)
    end
    
    it "should have the right macropost in the right order" do
      @user.macroposts.should == [@mp2, @mp1]
    end
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
  
  describe 'password validations' do
    
    it "should require a pssword" do
      lolcat = User.new(@attr.merge( :password => '' , :password_confirmation => '' ) )
      lolcat.should_not be_valid
    end
    
    it "should have matching password and confirmation" do
      lolcat = User.new(@attr.merge( :password_confirmation => 'invalid' ) )
      lolcat.should_not be_valid
    end
    
    it "should not be too short a password" do
      sh_pas = 'a'*3
      lolcat = User.new(@attr.merge( :password => sh_pas, :password_confirmation => sh_pas ) )
      lolcat.should_not be_valid
    end
    
    it "should not be too long a password" do
      l_pas = 'a'*129
      lolcat = User.new(@attr.merge( :password => l_pas , :password_confirmation => l_pas ) )
      lolcat.should_not be_valid
    end
  end
  
  describe 'password encryption' do
    
    before(:each) do
      @myuser = User.create!(@attr)
    end
    
    it "should have an encrypted password" do
      @myuser.should respond_to(:encrypted_password)
    end
    
    it "should set the encrypted password" do
      @myuser.encrypted_password.should_not be_blank
    end
    
    it "should know when it has received a correct password" do
      result = @myuser.has_password?( @myuser.password )
      result.should_not be_false
    end
    
    it "should know when the password input is incorrect" do
      result = @myuser.has_password?( 'lolcat' )
      result.should be_false
    end
    
    describe "password authentication" do
    
      it "should return nil if the user isn't in our database" do
        result = User.authenticate( 'happycat@lol.cat' , @myuser.password )
        result.should be_nil
      end
      
      it "should return nil if the user input the incorrect password" do
        result = User.authenticate( @myuser.email , 'lolcat' )
        result.should be_nil
      end
      
      it "should return an user resource if everything is successful" do
        result = User.authenticate( @myuser.email, @myuser.password )
        result.should == @myuser
      end
    end
    
    describe "admin attributes" do
    
      before(:each) do
        @user = @myuser
      end
      
      it "should respond to admin" do
        @user.should respond_to(:admin)
      end
      
      it "should not be an admin by default" do
        @user.should_not be_admin
      end
      
      it "should be convertible to an admin" do
        @user.toggle!(:admin)
        @user.should be_admin
      end
    end
    
  end
end
