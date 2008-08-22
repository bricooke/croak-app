#
#  Error.rb
#  Croak
#
#  Created by Brian Cooke on 8/21/08.
#  Copyright (c) 2008 roobasoft, LLC. All rights reserved.
#
require 'active_resource'

class Hoptoad < ActiveResource::Base
  self.site = "http://makalumedia.hoptoadapp.com"
 
  class << self
    # TODO remove this user 
    @@auth_token = 'edb7991e0bca045f99827bb762c18cf19bd2a288'
 
    def find(*arguments)
      arguments = append_auth_token_to_params(*arguments)
      super(*arguments)
    end
    
    def append_auth_token_to_params(*arguments)
      opts = arguments.last.is_a?(Hash) ? arguments.pop : {}
      opts = opts.has_key?(:params) ? opts : opts.merge(:params => {})
      opts[:params] = opts[:params].merge(:auth_token => @@auth_token)
      arguments << opts
      arguments
    end
  end
end

class Error < Hoptoad
  def to_hash
    {
      :id => id,
      :error_message => error_message,
      :last_notice_at => last_notice_at.to_s(:short),
      :notices_count => notices_count
    }
  end
  
  def isEqual(right)
    self[:id] == right[:id]
  end
end
