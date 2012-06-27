#TODO: specme
module DoctorSwagger
  class RootSwaggerDoc < SwaggerDoc
    def initialize(base_path_extension, options = {}, &block)
      @swagger_version = options.fetch(:swagger_version, DoctorSwagger.swagger_version)
      @api_version     = options.fetch(:api_version, DoctorSwagger.api_version)
      @base_path       = (options.fetch(:base_path, DoctorSwagger.base_path))
      @base_path ||= ""
      @base_path += base_path_extension
      @endpoints       = []
      instance_eval(&block)
    end
  end
end
