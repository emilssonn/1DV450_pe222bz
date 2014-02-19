class ExistenceValidator < ActiveModel::EachValidator
  
  def validate_each(record, attribute, value)
    attr_before = "#{attribute}_id_before_type_cast".to_sym
    attr_after = "#{attribute}_id".to_sym
    if value.blank? && record.send(attr_before).blank?
      record.errors[attr_after] << (options[:message] || "can't be blank")
		elsif !record.send(attr_before).blank?
      if !record.send(attr_before).include?('-')
        id = attribute.to_s.singularize.camelize.constantize.select(:id).find_by_id(record.send(attr_after)) rescue nil
      else
        id = attribute.to_s.singularize.camelize.constantize.select(:id).find_by_public_id(record.send(attr_before)) rescue nil
      end
			puts id.id
      if id && id.id
        puts id.id
        attr_after = 2
      else
        record.errors[attr_after] << (options[:message] || "is not a valid id")
      end
    end
  end
end
