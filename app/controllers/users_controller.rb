class UsersController < ApplicationController
  before_filter :authenticate, :only => [:edit, :update, :index] 
  before_filter :correct_user, :only => [:edit, :update ]
  before_filter :admin_user, :only => :destroy
  before_filter :logged_in_user , :only => [:new, :create]
  
  def destroy
    targetuser = User.find_by_id(params[:id])
    if current_user.id == targetuser.id
      flash[:error] = "Admins cannot delete themselves"
    else
      flash[:success] = "User destroyed"
      targetuser.destroy
    end
    redirect_to users_path
  end
  
  def index
    @title = "All users"
    @users = User.paginate(:page => params[:page], :per_page => 30)
  end
  
  def edit
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
    @macroposts = @user.macroposts.paginate(:page => params[:page], :per_page => 10)
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
  
  private
    
    
    
    def correct_user
      @user = User.find_by_id(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end
    
    def admin_user
      if not signed_in?
        deny_access
      else
        redirect_to(root_path) unless current_user.admin?
      end
    end
    
    def logged_in_user
      redirect_to(root_path) if signed_in?
    end
end
