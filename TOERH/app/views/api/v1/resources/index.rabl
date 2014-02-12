object @x => :collection

node(:self) do 
	request.original_url
end
	
node(:items) do
	@resources.each do |r|
		partial("resources/show, :object => r")
	end
end


