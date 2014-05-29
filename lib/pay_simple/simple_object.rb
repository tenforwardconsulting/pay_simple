module PaySimple
  class SimpleObject
    SHARED_ATTRIBUTES = [:id, :last_modified, :created_on]
    attr_accessor *SHARED_ATTRIBUTES

    class << self 
      def find(id, client=nil)
        instance = self.new
        instance.id = id
        client ||= PaySimple::Client.new
        client.fetch(instance)

        raise "Error finding #{self.name} with id #{id}" if client.error?

        instance
      end
    end
    
    def self.required_attributes(*args)
      @required_attributes ||= []
      args.each do |arg|
        @required_attributes.push arg
        attr_accessor arg
      end
      @required_attributes
    end

    def self.optional_attributes(*args)
      @optional_attributes ||= []
      args.each do |arg|
        @optional_attributes.push arg
        attr_accessor arg
      end
      @optional_attributes
    end

    # options: 
    #   class_name: "Account::Ach"
    #   multiple: true/false
    #   endpoint: api endpoint if different from the name
    def self.association(name, options={})
      @associations ||= {}

      attr_accessor name
      options[:class_name] = name.to_s.capitalize if options[:class_name].nil?
      options[:endpoint] = name.to_s if options[:endpoint].nil?

      @associations[name] = options
      @associations
    end

    def self.associations
      @associations ||= {}
    end

    def self.belongs_to(name, options={})
      association(name, options)
    end

    def self.has_one(name, options={})
      association(name, options)
    end

    def self.has_many(name, options={})
      options[:multiple] = true
      association(name, options)
    end

    def initialize(attributes={})
      attributes.each do |k,v|
        if self.respond_to? k
          self.send("#{k}=", v)
        end
      end 
    end

    def serialized_attributes
      all = self.class.required_attributes + self.class.optional_attributes
      self.class.associations.each do |association, association_info|
        if (association_info[:serialize])
          all << association
        end
      end
      all
    end

    def as_json
      attributes = {}
      self.serialized_attributes.each do |attribute|
        value = self.send(attribute.to_sym)
        if (value.respond_to? :as_json)
          value = value.as_json
        end
        attributes[camel_case(attribute)] = value
      end

      attributes
    end

    def valid? 
      self.class.required_attributes.each do |required_attribute|
        value = self.send(required_attribute.to_sym)
        if (value.nil? || value == [] || value == {} || value == "")
          return false
        end
      end
      true
    end

    # data here is a hash with CapitalCase strings and values that is returned from the API
    def hydrate(data)
      data.each do |k,v|
        getter = "#{underscore_case(k)}".to_sym
        setter = "#{underscore_case(k)}=".to_sym
        if self.respond_to? getter
          if v.kind_of? Hash
            object = self.send(getter)
            if (object.kind_of? SimpleObject)
              object.hydrate(v)
            elsif object.nil?
              puts "don't know what to do with #{k}"
            end
          else
            self.send(setter, v)
          end
        else
          puts "Unknown attribute #{k} in hydrate"
        end
      end
      self
    end

    def to_json
      as_json.to_json
    end

    def camel_case(attribute)
      parts = attribute.to_s.split("_")
      parts.collect(&:capitalize).join('')
    end

    def underscore_case(attribute)
      attribute.
      gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
      gsub(/([a-z\d])([A-Z])/,'\1_\2').
      tr("-", "_").
      downcase
    end
  end
end