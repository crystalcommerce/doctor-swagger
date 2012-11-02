require 'kramdown'

module DoctorSwagger
  class Operation
    def initialize(nickname, &block)
      @nickname = nickname
      @summary  = ''
      @parameters = []
      @error_responses = []
      @embeds = []
      @scopes = []
      @type   = ""
      @internal_type = ""
      instance_eval(&block)
      add_embedded_parameter unless @embeds.empty?
    end

    def query_parameter(param, &block)
      @parameters << QueryParameter.new(param, &block)
    end

    def path_parameter(param, &block)
      @parameters << PathParameter.new(param, &block)
    end

    def post_parameter(param, &block)
      @parameters << PostParameter.new(param, &block)
    end

    def header_parameter(param, &block)
      @parameters << HeaderParameter.new(param, &block)
    end

    def post_body(&block)
      @parameters << PostBody.new(&block)
    end

    def method(meth)
      @method = meth
    end

    def notes(notes)
      @notes = process_markdown(notes)
    end

    def summary(summary)
      @summary = summary
    end

    def standard_errors
      @error_responses |= Errors.standard_errors
    end

    def error(http_status, error)
      @error_responses << ErrorResponse.new(http_status, error)
    end

    def embeds(*embeds)
      @embeds |= embeds
    end

    def scopes(*scopes)
      @scopes |= scopes
    end

    def type(type)
      @type = type
    end

    def internal_type(internal_type)
      @internal_type = internal_type
    end

    def as_json(*)

      {
        'parameters'           => @parameters.map(&:as_json),
        'httpMethod'           => @method.to_s.upcase,
        'notes'                => @notes,
        'embeds'               => @embeds.map(&:to_s),
        'scopes'               => @scopes.map(&:to_s),
        'errorResponses'       => @error_responses.map(&:as_json),
        'summary'              => @summary,
        'nickname'             => @nickname.to_s,
        'responseClass'        => @type,
        'responseTypeInternal' => @internal_type
      }
    end

  private
    def add_embedded_parameter
      embeds = @embeds
      query_parameter(:embedded) do
        description "Optional records to embed, comma-separated"
        allow_multiple! if embeds.length > 1
        allowable_values(*embeds)
      end
    end

    def process_markdown(text)
      Kramdown::Document.new(text, :input => :markdown,
                                   :auto_ids => false).to_html
    end
  end
end
