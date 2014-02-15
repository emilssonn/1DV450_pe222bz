object @x => :collection

node(:self) { request.original_url }
	
node(:items) do
	@resources.each do |r|
		partial("resources/_show, :object => r")
	end
end

if @resources.empty?
	node(:prev) { nil }
	node(:next) { nil }
else
	node(:prev) { nil }
	node(:next) { nil }
end

node(:total) { @resources.count }
node(:limit) { @limit }
node(:offset) { @offset }


