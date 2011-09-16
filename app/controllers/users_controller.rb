class UsersController < ApplicationController

  def edit
    @user = User.find_by_id(params[:id])
    @title = "Edit user"
  end
  
  def update
    @user = User.find_by_id(params[:id])
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      @title = "Edit user"
      render 'edit'
    end
  end
  
  def new
    @user = User.new
    @title = "Sign up"
  end
  
  def show
    @user = User.find(params[:id])
    @title = @user.username
  end

  def create
    @user = User.new(params[:user])
      if @user.save
        flash[:success] = "Welcome!"
        sign_in(@user)
        redirect_to @user
      else
        @title = "Sign up"
        @user.password = ''
        @user.password_confirmation = '' 
        render 'new'
      end
  end
end
