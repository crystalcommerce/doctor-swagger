module DoctorSwagger
  class ErrorResponse
    def initialize(code, reason)
      @code   = code
      @reason = reason
    end

    def as_json(*)
      {
        'code'   => @code,
        'reason' => @reason
      }
    end
  end
end
