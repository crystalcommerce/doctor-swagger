module DoctorSwagger
  class SwaggerDoc
    SWAGGER_VERSION = '1.0'

    def initialize(resource_path, &block)
      @resource_path = resource_path
      @endpoints = []
      instance_eval(&block)
    end

    def endpoint(path, &block)
      @endpoints << Endpoint.new(path, &block)
    end

    def base_path
      if Rails.env.development?
        'http://localhost:3002/api/v1'
      else
        protocol = Rails.env.stage_production? ? 'http' : 'https'
        tld = Rails.env.stage_production? ? 'local' : 'com'
        "#{protocol}://#{Hijacker.current_client}-api.crystalcommerce.#{tld}/v1"
      end
    end

    def as_json(*)
      {
        'apiVersion'     => Api::V1::Version::STRING,
        'swaggerVersion' => SWAGGER_VERSION,
        'basePath'       => base_path,
        'resourcePath'   => @resource_path,
        'apis'           => @endpoints.map(&:as_json)
      }
    end
  end
end
