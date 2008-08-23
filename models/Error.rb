#
#  Error.rb
#  Croak
#
#  Created by Brian Cooke on 8/21/08.
#  Copyright (c) 2008 roobasoft, LLC. All rights reserved.
#
require 'active_resource'
require File.dirname(__FILE__) + "/active_resource_instance_authentication/init.rb"

class Error < ActiveResource::Base
  self.site = ""
  
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
