module DoctorSwagger
  module ClassMethods
    def swagger_doc
      @swagger_doc
    end

    def swagger_resource(resource_path, &block)
      @swagger_doc = SwaggerDoc.new(resource_path, &block)
    end

    def swagger_root_resource(resource_path, &block)
      @swagger_doc = RootSwaggerDoc.new(resource_path, &block)
    end
  end

  def self.included(receiver)
    receiver.extend(ClassMethods)
  end
end

require "doctor_swagger/version"
