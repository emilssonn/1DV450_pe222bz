object @x => :collection

node(:self) { request.original_url }
	
node(:items) do
	partial("api/v1/tags/_show", :object => @tags.each)
end

if @tags.empty?
	node(:prev) { nil }
	node(:next) { nil }
else
	node(:prev) { nil }
	node(:next) { nil }
end

node(:total) { @licenses.count }
node(:limit) { @limit }
node(:offset) { @offset }


