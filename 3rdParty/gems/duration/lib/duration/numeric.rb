# Additional methods added to numeric objects allow the developer to construct
# a calculated number of seconds through human-readable methods.
#
#   60.seconds #=> 60
#   60.minutes #=> 3600
#   ... and so on
#
# Singular methods are also defined.
#
#   1.minute #=> 60
#   1.hour   #=> 3600
#   ... and so on
class Numeric
  # Number of seconds (equivalent to Numeric#to_i)
  def seconds
    to_i
  end unless Numeric.instance_methods.include? 'seconds'
  
  # Number of seconds using the number as the base of minutes.
  def minutes
    to_i * 60
  end unless Numeric.instance_methods.include? 'minutes'
  
  # Number of seconds using the number as the base of hours.
  def hours
    to_i * 3600
  end unless Numeric.instance_methods.include? 'hours'
  
  # Number of seconds using the number as the base of days.
  def days
    to_i * 86400
  end unless Numeric.instance_methods.include? 'days'
  
  # Number of seconds using the number as the base of weeks.
  def week
    to_i * 604800
  end unless Numeric.instance_methods.include? 'weeks'
  
  # Number of seconds (singular form).
  def second
    to_i
  end unless Numeric.instance_methods.include? 'second'
  
  # Number of seconds using the number as the base of minutes (singular form).
  def minute
    to_i * 60
  end unless Numeric.instance_methods.include? 'minute'
  
  # Number of seconds using the number as the base of hours (singular form).
  def hour
    to_i * 3600
  end unless Numeric.instance_methods.include? 'hour'
  
  # Number of seconds using the number as the base of days (singular form).
  def day
    to_i * 86400
  end unless Numeric.instance_methods.include? 'day'
  
  # Number of seconds using the number as the base of weeks (singular form).
  def week
    to_i * 604800
  end unless Numeric.instance_methods.include? 'week'
end