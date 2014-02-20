object @x => :collection

node(:self) { request.original_url }
	
node(:items) do
	partial("api/v1/tags/_show", :object => @tags.each)
end

if @tags.empty?
	node(:prev) { prev_link(@limit, @offset) }
	node(:next) { nil }
else
	node(:prev) { prev_link(@limit, @offset) }
	node(:next) { next_link(@limit, @offset) }
end

node(:total) { @tags.count }
node(:limit) { @limit }
node(:offset) { @offset }


