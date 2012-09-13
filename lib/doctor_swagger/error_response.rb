module DoctorSwagger
  class ErrorResponse
    def initialize(http_status, error)
      @error       = error
      @http_status = http_status
    end

    def as_json(*)
      {
        'error'       => @error,
        'http_status' => @http_status
      }
    end
  end
end
