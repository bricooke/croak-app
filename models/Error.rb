#
#  Error.rb
#  Croak
#
#  Created by Brian Cooke on 8/21/08.
#  Copyright (c) 2008 roobasoft, LLC. All rights reserved.
#
require 'active_resource'
require 'duration'

require File.dirname(__FILE__) + "/active_resource_instance_authentication/init.rb"

class Error < ActiveResource::Base
  attr_accessor :domain
  
  self.site = ""
  
  def self.fuzzy_last_notice_at(time)
    duration = Duration.new(Time.now - time)

    w = "week"
    w = w.pluralize if duration.weeks != 1

    d = "day"
    d = d.pluralize if duration.days != 1

    h = "hour"
    h = h.pluralize if duration.hours != 1
    
    m = "minute"
    m = m.pluralize if duration.minutes != 1
    
    return "about #{duration.weeks.to_s} #{w} ago" if duration.weeks > 0
    return "#{duration.days.to_s} #{d} ago" if duration.days > 0 
    return "#{duration.hours.to_s} #{h} ago" if duration.hours > 0
    return "#{duration.minutes.to_s} #{m} ago" if duration.minutes > 0
    
    return duration.to_s + " ago"
  end
  
  def to_hash
    {
      :id => id,
      :error_message => error_message || "",
      :file => File.basename(file || ""),
      :line_number => line_number.to_s || "",
      :last_notice_at => last_notice_at,
      :notices_count => notices_count,
      :domain => domain
    }
  end

  def isEqual(right)
    self[:id] == right[:id]
  end
end
