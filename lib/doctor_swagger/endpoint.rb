module DoctorSwagger
  class Endpoint
    def initialize(path, &block)
      @path = path
      @operations = []
      instance_eval(&block)
    end

    def operations_as_json
      if @operations.present?
        {'operations' => @operations.map(&:as_json)}
      else
        {}
      end
    end

    def as_json(*)
      {
        'path' => @path,
        'description' => @description,
      }.merge(operations_as_json)
    end

    def description(desc)
      @description = desc
    end

    def operation(nickname, &block)
      @operations << Operation.new(nickname, &block)
    end
  end
end
