object @x => :collection

node(:self) { request.original_url }
	
node(:items) do
	@resource_types.each do |r|
		partial("resource_types/_show, :object => r")
	end
end

if @resource_types.empty?
	node(:prev) { nil }
	node(:next) { nil }
else
	node(:prev) { nil }
	node(:next) { nil }
end

node(:total) { @resource_types.count }
node(:limit) { @limit }
node(:offset) { @offset }


