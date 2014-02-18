class ExistenceValidator < ActiveModel::EachValidator
  
  def validate_each(record, attribute, value)
  	test = "#{attribute}_id".to_sym
    if value.blank? && record.send(test).blank?
      record.errors[test] << (options[:message] || "can't be blank")
		elsif !record.send(test).blank?
			id = attribute.to_s.singularize.camelize.constantize.select(:id).find_by_public_id(record.send(test)) rescue nil
      if id && id.id
        attribute = id.id
      else
        record.errors[test] << (options[:message] || "is not a valid id")
      end
    end
  end
end
