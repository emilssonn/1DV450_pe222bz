object @x => :collection

node(:self) { request.original_url }
	
node(:items) do
	@licenses.each do |l|
		partial("licenses/_show, :object => l")
	end
end

if @licenses.empty?
	node(:prev) { nil }
	node(:next) { nil }
else
	node(:prev) { nil }
	node(:next) { nil }
end

node(:total) { @licenses.count }
node(:limit) { @limit }
node(:offset) { @offset }


