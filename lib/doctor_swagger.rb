require 'doctor_swagger/endpoint'
require 'doctor_swagger/swagger_doc'
require 'doctor_swagger/error_response'
require 'doctor_swagger/errors'
require 'doctor_swagger/operation'
require 'doctor_swagger/parameter'
require 'doctor_swagger/query_parameter'
require 'doctor_swagger/post_parameter'
require 'doctor_swagger/path_parameter'
require 'doctor_swagger/header_parameter'
require 'doctor_swagger/post_body'
require 'doctor_swagger/root_swagger_doc'

module DoctorSwagger
  #global settings, override with DSL
  def self.swagger_version
    @swagger_version ||= '1.0'
  end

  def self.api_version
    @api_version ||= lambda { raise 'Set your API version with DoctorSwagger.api_version= or at the resource level'}
  end

  def self.base_path
    @base_path ||= lambda { raise 'Set your base URL with DoctorSwagger.base_path= or at the resource level'}
  end

  def self.swagger_version=(version)
    @swagger_version = version
  end

  def self.api_version=(version)
    @api_version = version
  end

  def self.base_path=(url)
    @base_path = url
  end

  module ClassMethods
    def swagger_version(version)
      @swagger_version = version
    end

    def api_version(version)
      @api_version = version
    end

    def base_path(url)
      @base_path = url
    end

    def swagger_doc
      @swagger_doc
    end

    def swagger_resource(resource_path, &block)
      @swagger_doc = SwaggerDoc.new(resource_path,
                                    :swagger_version => @swagger_version,
                                    :api_version     => @api_version,
                                    :base_path       => @base_path,
                                    &block)
    end

    def swagger_root_resource(resource_path, &block)
      @swagger_doc = RootSwaggerDoc.new(resource_path,
                                        :swagger_version => @swagger_version,
                                        :api_version     => @api_version,
                                        :base_path       => @base_path,
                                        &block)
    end
  end

  def self.included(receiver)
    receiver.extend(ClassMethods)
  end
end

require "doctor_swagger/version"
