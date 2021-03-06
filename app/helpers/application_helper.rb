module ApplicationHelper

	def site_title
		return Settings.site_title unless Settings.site_title.nil?
		return 'Showbot'
	end

	def full_title(page_title)
		base_title = site_title
		if page_title.empty?
			base_title
		else
			"#{base_title} | #{page_title}"
		end
	end

	def current_user
		if session[:userid]
			@current_user ||= User.find(session[:userid])
		else
			@current_user = nil
		end
	end

	def check_api_key
		authenticate_or_request_with_http_token do |token, options|
			Api.exists?(api_key: token)
		end
	end

	def check_admin
		check_oauth
		if admin?
			return true
		else
			redirect_to root_url
		end
	end

	def admin?
		if current_user && current_user.admin
			return true
		else
			return false
		end
	end

	def check_oauth
		unless logged_in?
			redirect_to "/auth/twitter"
		end
	end

	def logged_in?
		if session[:userid]
			return true
		else
			return false
		end
	end

end
