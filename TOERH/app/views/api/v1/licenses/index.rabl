object @x => :collection

node(:self) { request.original_url }
	
node(:items) do
	partial("api/v1/licenses/_show", :object => @licenses.each)
end

if @licenses.empty?
	node(:prev) { prev_link(@limit, @offset) }
	node(:next) { nil }
else
	node(:prev) { prev_link(@limit, @offset) }
	node(:next) { next_link(@limit, @offset) }
end

node(:total) { @licenses.count }
node(:limit) { @limit }
node(:offset) { @offset }


