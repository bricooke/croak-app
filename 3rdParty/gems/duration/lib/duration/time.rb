class Time
  def to_duration
    Duration.new(self)
  end
  
  alias_method :duration, :to_duration
end