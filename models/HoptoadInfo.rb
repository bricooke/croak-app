class HoptoadInfo
  attr_accessor :domain, :auth_token
  
  def self.find
    domains = NSUserDefaults.standardUserDefaults.arrayForKey("hoptoad_domains")
    domains ||= []
    
    @@hoptoads = []
    domains.each do |domain|
      keychainItem = EMKeychainProxy.sharedProxy.genericKeychainItemForService_withUsername_("Croak Hoptoad Auth Token", domain);
      @@hoptoads << HoptoadInfo.create({:domain => domain, :auth_token => keychainItem.password})
    end
    @@hoptoads
  end
  
  def self.create(params)
    HoptoadInfo.new(params[:domain], params[:auth_token])
  end
  
  def self.recent_errors
    @@hoptoads = self.find if @@hoptoads.nil? || @@hoptoads.empty?
    
    e = []
    @@hoptoads.each do |h|
      e += h.recent_errors
    end
    
    e.sort_by(&:last_notice_at)
  end
  
  def initialize(d, a)
    @domain = d
    @auth_token = a
  end
  
  def valid?
    begin
      self.recent_errors
      true
    rescue Exception => e
      NSLog(e.message)
      false
    end
  end
  
  def recent_errors
    require "Error.rb" unless defined?(Error)

    Error.find(:all, :connection => ActiveResource::Connection.new("http://#{@domain}.hoptoadapp.com"), :params => {:auth_token => @auth_token})
  end
  
  def save
    return false unless self.valid?
    
    # save the auth token in the keychain
    keychainItem = EMKeychainProxy.sharedProxy.genericKeychainItemForService_withUsername_("Croak Hoptoad Auth Token", @domain);
    keychainItem ||= EMKeychainProxy.sharedProxy.addGenericKeychainItemForService_withUsername_password("Croak Hoptoad Auth Token", @domain, @auth_token);

    keychainItem.setPassword(@auth_token)
    
    domains = NSUserDefaults.standardUserDefaults.arrayForKey("hoptoad_domains")
    domains ||= []
    domains << @domain unless domains.include?(@domain)
    
    NSUserDefaults.standardUserDefaults.setObject_forKey_(domains, "hoptoad_domains")
    
    true
  end
end