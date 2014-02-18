object @x => :collection

node(:self) { request.original_url }
	
node(:items) do
	partial("api/v1/resources/_show", :object => @resources.each)
end

if @resources.empty?
	node(:prev) { nil }
	node(:next) { nil }
else
	node(:prev, :if => lambda { |r| @offset == 0 }) { nil }
	node(:prev, :if => lambda { |r| @offset > 0 }) { nil }
	node(:next) { nil }
end

node(:total) { @resources.count }
node(:limit) { @limit }
node(:offset) { @offset }


