module PaySimple
  class SimpleObject
    SHARED_ATTRIBUTES = [:id, :last_modified, :created_on]
    attr_accessor *SHARED_ATTRIBUTES

    class << self 
      attr_accessor :required_attributes, :optional_attributes
    end
    
    def self.required_attributes(*args)
      @required_attributes ||= []
      args.each do |arg|
        @required_attributes.push arg
        attr_accessor arg
      end
    end
    def self.optional_attributes(*args)
      @optional_attributes ||= []
      args.each do |arg|
        @optional_attributes.push arg
        attr_accessor arg
      end
    end

    def all_attributes
      SHARED_ATTRIBUTES + self.class.instance_variable_get(:"@required_attributes") + self.class.instance_variable_get(:"@optional_attributes")
    end

    def as_json
      attributes = {}
      self.all_attributes.each do |attribute|
        value = self.send(attribute.to_sym)
        if (value.respond_to? :as_json)
          value = value.as_json
        end
        attributes[camel_case(attribute)] = value
      end
      attributes
    end

    def to_json
      as_json.to_json
    end

    def camel_case(attribute)
      parts = attribute.to_s.split("_")
      parts.collect(&:capitalize).join('')
    end
  end
end