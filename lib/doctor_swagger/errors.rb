module DoctorSwagger
  module Errors
    def self.standard_errors
      [resource_not_found, access_denied]
    end

    def self.resource_not_found
      ErrorResponse.new(404, 'resource_not_found')
    end

    def self.access_denied
      ErrorResponse.new(401, 'access_denied')
    end
  end
end
