class MacropostsController < ApplicationController
  before_filter :authenticate, :only => [ :create , :destroy ]
  before_filter :authorized_user, :only => :destroy
  
  def create
    @macropost = current_user.macroposts.build(params[:macropost])
    if @macropost.save
      flash[:success] = "Macropost successfully created!"
      redirect_to root_path
    else
      flash[:error] = "Macropost creation failed terribly"
      redirect_to 'pages/home'
    end
  end
  
  def destroy
    @macropost.destroy
    redirect_back_or root_path
  end
  
  private
  
    def authorized_user
      @macropost = current_user.macroposts.find_by_id(params[:id])
      redirect_to root_path if @macropost.nil?
    end
end
