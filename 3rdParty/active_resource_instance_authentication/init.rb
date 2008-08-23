require File.join(File.dirname(__FILE__), "/lib/active_resource_instance_authentication")
ActiveResource::Base.send(:include, ActiveResourceInstanceAuthentication)
