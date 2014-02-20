object @x => :collection

node(:self) { request.original_url }
	
node(:items) do
	partial("api/v1/users/_show", :object => @users.each)
end

if @users.empty?
	node(:prev) { nil }
	node(:next) { nil }
else
	node(:prev) { nil }
	node(:next) { nil }
end

node(:total) { @users.count }
node(:limit) { @limit }
node(:offset) { @offset }


