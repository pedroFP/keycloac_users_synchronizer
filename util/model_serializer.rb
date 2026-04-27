# Allow model instances to be serialized as hash and json

module ModelSerializer
  include ActiveModel::Serialization

  def attributes
    instance_variables.each_with_object({}) do |var, hash|
      hash[var.to_s.delete('@')] = instance_variable_get(var)
    end
  end

  def to_h
    serializable_hash.transform_values do |value|
      value.respond_to?(:to_h) ? value.to_h : value
    end
  end
end
