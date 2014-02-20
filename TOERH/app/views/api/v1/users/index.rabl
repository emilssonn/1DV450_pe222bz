object @x => :collection

node(:self) { request.original_url }
	
node(:items) do
	partial("api/v1/users/_show", :object => @users.each)
end

if @users.empty?
	node(:prev) { prev_link(@limit, @offset) }
	node(:next) { nil }
else
	node(:prev) { prev_link(@limit, @offset) }
	node(:next) { next_link(@limit, @offset) }
end

node(:total) { @users.count }
node(:limit) { @limit }
node(:offset) { @offset }


