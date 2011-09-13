module ApplicationHelper
	
	# Declaring some variables
	def about_path
	  return '/about'
	end
  
  def contact_path
    return '/contact'
  end
  
  def home_path
    return '/'
  end
  
  def help_path
    return '/help'
  end
  
  def sign_up_path
    return '/signup'
  end
  
  def users_path
    return '/users'
  end
  	
	# Deals with the title for a page to be honest, I have no clue how it works
	def title
		base_title = "CoTABit"
		if @title.nil?
			return base_title
		else
			return "#{base_title} | #{@title}"
		end
	end
	
	# Ideally puts stuff into the <nav> tags on the application page
end
