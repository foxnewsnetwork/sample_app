class SessionsController < ApplicationController
  def new
    @title = 'Sign in'
  end
  
  # Creates a user session
  def create
    myuser = User.authenticate( params[:sessions][:email], 
    params[:sessions][:password] )
    
    if myuser.nil?
      flash.now[:error] = "Invalid email/password combination"
      @title = "Sign in"
      render 'new'
    else
      sign_in myuser
      redirect_back_or myuser
    end
  end
  
  # Destroys a user session
  def destroy
    sign_out
    redirect_to root_path
  end
  
  
  
  
end
