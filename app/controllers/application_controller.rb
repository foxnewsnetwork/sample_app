class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper # Necessary to make the helper availible in the controller

end
