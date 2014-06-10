module ApplicationHelper
	def full_title(page_title)
		base_title = 'I Got Played'
		if page_title.empty?
			base_title
		else
			page_title
		end 
	end 
end
