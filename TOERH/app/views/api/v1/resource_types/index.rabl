object @x => :collection

node(:self) { request.original_url }
	
node(:items) do
	partial("api/v1/resource_types/_show", :object => @resource_types.each)
end

if @resource_types.empty?
	node(:prev) { prev_link(@limit, @offset) }
	node(:next) { nil }
else
	node(:prev) { prev_link(@limit, @offset) }
	node(:next) { next_link(@limit, @offset) }
end

node(:total) { @resource_types.count }
node(:limit) { @limit }
node(:offset) { @offset }


