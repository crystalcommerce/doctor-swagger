module DoctorSwagger
  class PostBody < PostParameter
    def initialize(&block)
      super(:body, &block)
    end

    def example(example)
      @example = example
    end

    def as_json(*)
      if @example.present?
        super.merge('example' => @example)
      else
        super
      end
    end
  end
end
