module TitleHelper
	def set_heading(heading)
		@heading = heading
	end

	def set_title(title)
		@title = title
	end

	def title
		@title || "RS-App | Set Title - TitleHelper"
	end
end
