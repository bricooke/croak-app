module ActiveResourceInstanceAuthentication
  def self.included(base)
    base.class_eval("remove_method :connection")
    %w{get put post delete}.each do |instance_method|
      base::InstanceMethods.class_eval("remove_method :#{instance_method}")
    end
    %w{get put post delete find find_every find_one find_single}.each do |class_method|
      base.class_eval("class << self ; remove_method :#{class_method} ; end")
    end
    base.extend ClassMethods
  end
  module ClassMethods
    # for a perfectly consistent plugin, we should have adapted format as well as the other
    # methods, but the thing is, our code doesn't need #format, so, later for that.
    def get(method_name, options = {})
      http_connection = options.delete(:connection) || connection
      http_connection.get(custom_method_collection_url(method_name, options), headers)
    end

    def post(method_name, options = {}, body = '')
      http_connection = options.delete(:connection) || connection
      http_connection.post(custom_method_collection_url(method_name, options), body, headers)
    end

    def put(method_name, options = {}, body = '')
      http_connection = options.delete(:connection) || connection
      http_connection.put(custom_method_collection_url(method_name, options), body, headers)
    end

    def delete(custom_method_name, options = {})
      http_connection = options.delete(:connection) || connection
      if custom_method_name.is_a? Symbol
        http_connection.delete(custom_method_collection_url(custom_method_name, options), headers)
      else
        http_connection.delete(element_path(custom_method_name, options))
      end
    end

    def find(*arguments)
      scope   = arguments.slice!(0)
      options = arguments.slice!(0) || {}
      
      # here's a hack, which allows you to do this:
      #   Thing.find(:id => 1,
      #              :connection => ActiveResource::Connection.new("http://localhost:12345"))
      if scope.is_a?(Hash) && scope[:connection] && scope[:id]
        options[:connection] = scope[:connection]
        scope = scope[:id]
      end
      # the hack is required because Rails actually has a bit of an abstraction leak going on here
      # (in my opinion). if you pass it an id:
      #
      #   Thing.find(1)
      #
      # it actually assigns 1 to scope. it's not *really* a leaky abstraction, if you read the docs
      # carefully, it's just a weird (or at least unusual) interpretation of "scope."

      case scope
        when :all   then find_every(options)
        when :first then find_every(options).first
        when :one   then find_one(options)
        else             find_single(scope, options)
      end
    end
    
    def find_every(options)
      http_connection = options.delete(:connection) || connection
      case from = options[:from]
      when Symbol
        instantiate_collection(get(from, options[:params]))
      when String
        path = "#{from}#{query_string(options[:params])}"
        instantiate_collection(http_connection.get(path, headers) || [])
      else
        prefix_options, query_options = split_options(options[:params])
        path = collection_path(prefix_options, query_options)
        instantiate_collection((http_connection.get(path, headers) || []), prefix_options)
      end
    end

    # Find a single resource from a one-off URL
    def find_one(options)
      http_connection = options.delete(:connection) || connection
      case from = options[:from]
      when Symbol
        instantiate_record(get(from, options[:params]))
      when String
        path = "#{from}#{query_string(options[:params])}"
        instantiate_record(http_connection.get(path, headers))
      end
    end

    # Find a single resource from the default URL
    def find_single(scope, options)
      http_connection = options.delete(:connection) || connection
      prefix_options, query_options = split_options(options[:params])
      path = element_path(scope, prefix_options, query_options)
      instantiate_record(http_connection.get(path, headers), prefix_options)
    end

    private :find_every, :find_one, :find_single
  end
  
  # instance methods
  def get(method_name, options = {})
    http_connection = options.delete(:connection) || connection
    http_connection.get(custom_method_element_url(method_name, options), self.class.headers)
  end

  def post(method_name, options = {}, body = '')
    http_connection = options.delete(:connection) || connection
    if new?
      http_connection.post(custom_method_new_element_url(method_name, options), (body.nil? ? to_xml : body), self.class.headers)
    else
      http_connection.post(custom_method_element_url(method_name, options), body, self.class.headers)
    end
  end

  def put(method_name, options = {}, body = '')
    http_connection = options.delete(:connection) || connection
    http_connection.put(custom_method_element_url(method_name, options), body, self.class.headers)
  end

  def delete(method_name, options = {})
    http_connection = options.delete(:connection) || connection
    http_connection.delete(custom_method_element_url(method_name, options), self.class.headers)
  end

  def connection(refresh = false)
    # an ivar @connection might also need to be able to do something with refresh, eventually
    @connection || self.class.connection(refresh)
  end

  def connection=(conn)
    @connection = conn
  end
end
