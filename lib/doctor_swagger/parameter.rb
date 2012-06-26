module DoctorSwagger
  class Parameter
    ALLOWED_TYPES = [:string, :integer, :long, :double, :boolean]
    class InvalidType < StandardError
      def initialize(bad_type)
        @message = "The type of '#{bad_type}' is not valid. Choose from #{ALLOWED_TYPES.inspect}"
      end
    end

    def initialize(name, &block)
      @name = name
      @description = ""
      @required = false
      @allow_multiple = false
      @allowable_values = []
      @data_type = :string
      instance_eval(&block)
    end

    def description(description)
      @description = description
    end

    def required!
      @required = true
    end

    def allow_multiple!
      @allow_multiple = true
    end

    def allowable_values(*values)
      @allowable_values |= values
    end

    def type(type)
      raise InvalidType.new(type) unless ALLOWED_TYPES.include?(type)
      @data_type = type
    end

    def allowable_values_as_json
      if @allowable_values.present?
        {
          'allowableValues' => {
            'valueType' => 'LIST',
            'values' => @allowable_values.map(&:to_s)
          }
        }
      else
        {}
      end
    end

    def as_json(*)
      {
        'name'            => @name.to_s,
        'description'     => @description,
        'dataType'        => @data_type.to_s,
        'required'        => @required,
        'allowMultiple'   => @allow_multiple,
        'paramType'       => param_type
      }.merge(allowable_values_as_json)
    end
  end
end
