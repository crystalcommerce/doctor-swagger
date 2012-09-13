require 'spec_helper'
require 'doctor-swagger'

describe DoctorSwagger do
  module DoctorSwaggerTest
    include DoctorSwagger

    swagger_version 'some crazy version'
    api_version '3.0'
    base_path       'https://example.com/api'

    swagger_resource '/products' do
      endpoint '/products' do
        description 'Products'

        operation :index do
          query_parameter :category_id do
            description 'The category id of the products you want'
            required!
            type :integer
          end

          method :get
          notes 'Returns lots of products'

          type '[product]'
          internal_type '[Product]'

          standard_errors
          error 418, "im_a_teapot"

          embeds :category, :variants
          scopes 'read-inventory', 'other-scope'
          summary 'Find products by category id'
        end
      end

      endpoint '/products/{product_id}' do
        description 'Show product'

        operation :show do
          path_parameter :product_id do
            description 'The product id of the product you want'
            required!
            type :integer
          end

          method :get
          notes 'Returns a product'

          type 'product'
          internal_type 'Product'

          standard_errors
          embeds :category, :variants
          scopes 'read-inventory', 'other-scope'
          summary 'Find product by product id'
        end

        operation :update do
          path_parameter :product_id do
            description 'The product id of the product you want'
            required!
            type :integer
          end

          post_body do
            description 'The JSON representation of the product'
            required!

            example 'product' => {
              'foo' => 'bar',
              'wat' => nil
            }
          end

          method :put
          notes 'Updates a product'

          type 'product'
          internal_type 'Product'

          standard_errors
          scopes 'read-inventory', 'other-scope'
          summary 'Update product by product id'
        end
      end
    end
  end

  subject { DoctorSwaggerTest.swagger_doc }

  before(:each) do
    @actual = DoctorSwaggerTest.swagger_doc
  end

  its(:as_json) do
    should == {
      'apiVersion' => '3.0',
      'swaggerVersion' => 'some crazy version',
      'basePath' => "https://example.com/api",
      'resourcePath' => '/products',
      'apis' => [
        {
          'path' => '/products',
          'description' => 'Products',
          'operations' => [
            {
              'parameters' => [
                {
                  'name' => 'category_id',
                  'description' => 'The category id of the products you want',
                  'dataType' => 'integer',
                  'required' => true,
                  'allowMultiple' => false,
                  'paramType' => 'query'
                },
                {
                  'name' => 'embedded',
                  'description' => 'Optional records to embed, comma-separated',
                  'dataType' => 'string',
                  'required' => false,
                  'allowMultiple' => true,
                  'paramType' => 'query',
                  'allowableValues' => {
                    'values' => %w[category variants],
                    'valueType' => 'LIST'
                  }
                }
              ],
              'httpMethod' => 'GET',
              'notes' => 'Returns lots of products',
              'embeds' => %w[category variants],
              'scopes' => %w[read-inventory other-scope],
              'responseTypeInternal' => '[Product]',
              'responseClass' => '[product]',
              'errorResponses' => [
                {
                  'error' => 'resource_not_found',
                  'http_status' => 404
                },
                {
                  'error' => 'access_denied',
                  'http_status' => 401
                },
                {
                  'error' => 'im_a_teapot',
                  'http_status' => 418
                }
              ],
              'summary' => 'Find products by category id',
              'nickname' => 'index'

            }
          ]
        },
        {
          'path' => '/products/{product_id}',
          'description' => 'Show product',
          'operations' => [
            {
              'parameters' => [
                {
                  'name' => 'product_id',
                  'description' => 'The product id of the product you want',
                  'dataType' => 'integer',
                  'required' => true,
                  'allowMultiple' => false,
                  'paramType' => 'path'
                },
                {
                  'name' => 'embedded',
                  'description' => 'Optional records to embed, comma-separated',
                  'dataType' => 'string',
                  'required' => false,
                  'allowMultiple' => true,
                  'paramType' => 'query',
                  'allowableValues' => {
                    'values' => %w[category variants],
                    'valueType' => 'LIST'
                  }
                }

              ],
              'httpMethod' => 'GET',
              'notes' => 'Returns a product',
              'embeds' => %w[category variants],
              'scopes' => %w[read-inventory other-scope],
              'responseTypeInternal' => 'Product',
              'responseClass' => 'product',
              'errorResponses' => [
                {
                  'error' => 'resource_not_found',
                  'http_status' => 404
                },
                {
                  'error' => 'access_denied',
                  'http_status' => 401
                }
              ],
              'summary' => 'Find product by product id',
              'nickname' => 'show',
              'scopes' => %w[read-inventory other-scope]

            },
            {
              'parameters' => [
                {
                  'name' => 'product_id',
                  'description' => 'The product id of the product you want',
                  'dataType' => 'integer',
                  'required' => true,
                  'allowMultiple' => false,
                  'paramType' => 'path'
                },
                {
                  'name' => 'body',
                  'description' => 'The JSON representation of the product',
                  'dataType' => 'string',
                  'required' => true,
                  'allowMultiple' => false,
                  'paramType' => 'post',
                  'example'   => {
                    'product' => {
                      'foo' => 'bar',
                      'wat' => nil
                    }
                  }
                },
              ],
              'httpMethod' => 'PUT',
              'notes' => 'Updates a product',
              'embeds' => %w[],
              'scopes' => %w[read-inventory other-scope],
              'responseTypeInternal' => 'Product',
              'responseClass' => 'product',
              'errorResponses' => [
                {
                  'error' => 'resource_not_found',
                  'http_status' => 404
                },
                {
                  'error' => 'access_denied',
                  'http_status' => 401
                }
              ],
              'summary' => 'Update product by product id',
              'nickname' => 'update',
              'scopes' => %w[read-inventory other-scope]

            }
          ]
        }
      ]
    }
  end

  context "dynamic version/path config" do
    class DynamicSwaggerResource
      include DoctorSwagger


      def self.prefix=(prefix)
        @prefix = prefix
      end

      def self.format(str)
        "#{@prefix}#{str}"
      end

      swagger_version lambda { DynamicSwaggerResource.format('some crazy version') }
      api_version     lambda { DynamicSwaggerResource.format('3.0') }
      base_path       lambda { DynamicSwaggerResource.format('https://example.com/api') }

      swagger_resource '/products' do
      end
    end

    subject { DynamicSwaggerResource.swagger_doc }

    before(:each) do
      DynamicSwaggerResource.prefix = '!!!'
    end

    its(:as_json) do
      should == {
        'apiVersion' => '!!!3.0',
        'swaggerVersion' => '!!!some crazy version',
        'basePath' => "!!!https://example.com/api",
        'resourcePath' => '/products',
        'apis' => []
      }
    end
  end
end
