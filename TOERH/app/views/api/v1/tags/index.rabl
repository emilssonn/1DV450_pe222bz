object @x => :collection

node(:self) { request.original_url }
	
node(:items) do
	@tags.each do |t|
		partial("tags/_show, :object => t")
	end
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


