object @x => :collection

node(:self) { request.original_url }
	
node(:items) do
	partial("api/v1/resources/_show", :object => @resources.each)
end

if @resources.empty?
	node(:prev) { prev_link(@limit, @offset) }
	node(:next) { nil }
else
	node(:prev) { prev_link(@limit, @offset) }
	node(:next) { next_link(@limit, @offset) }
end

node(:total) { @resources.count }
node(:limit) { @limit }
node(:offset) { @offset }


