module ApplicationHelper
	
	# Deals with the title for a page to be honest, I have no clue how it works
	def title
		base_title = "Ruby on Rails Tutorial Sample App"
		if @title.nil?
			return base_title
		else
			return "#{base_title} | #{@title}"
		end
	end
end
