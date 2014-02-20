module Api::V1::ApiBaseHelper

	# Returns a link to get the next collection
	def next_link limit, offset
		new_offset = offset + limit
		url = request.original_url
		if request.query_string.present? 
			if !url = request.original_url.sub(/offset=#{params[:offset]}*/, "offset=#{new_offset}")
				url = "#{request.original_url}&offset=#{new_offset}"
			end

			url2 = "";
			if !url2 = url.sub!(/limit=#{params[:limit]}*/, "limit=#{limit}")
				url.concat("&limit=#{limit}")
			end
		else
			url = "#{request.original_url}?limit=#{limit}&offset=#{new_offset}"
		end
		return url
	end

	# Returns a link to get the previous collection
	def prev_link limit, offset
		if offset != 0
			new_offset = (offset - limit <= 0 ? 0 : offset - limit)
			url = request.original_url.sub("offset=#{offset}", "offset=#{new_offset}")
			url2 = "";
			if !url2 = url.sub!(/limit=#{params[:limit]}*/, "limit=#{limit}")
				url.concat("&limit=#{limit}")
			end
			return url
		else
			return nil
		end
	end
end
