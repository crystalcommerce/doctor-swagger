#TODO: specme
module DoctorSwagger
  class RootSwaggerDoc < SwaggerDoc
    def initialize(base_path_extension, options = {}, &block)
      options[:swagger_version] ||= DoctorSwagger.swagger_version
      options[:api_version]     ||= DoctorSwagger.api_version
      options[:base_path]       ||= DoctorSwagger.base_path
      @swagger_version = options[:swagger_version]
      @api_version     = options[:api_version]
      @base_path       = options[:base_path]
      @base_path      += base_path_extension
      @endpoints       = []
      instance_eval(&block)
    end
  end
end
