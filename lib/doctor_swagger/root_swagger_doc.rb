module DoctorSwagger
  class RootSwaggerDoc < SwaggerDoc
    def initialize(base_path_extension, &block)
      @base_path_extension = base_path_extension
      @endpoints = []
      instance_eval(&block)
    end

    def as_json(*)
      {
        'apiVersion'     => Api::V1::Version::STRING,
        'swaggerVersion' => SWAGGER_VERSION,
        'basePath'       => base_path + @base_path_extension,
        'apis'           => @endpoints.map(&:as_json)
      }
    end
  end
end
