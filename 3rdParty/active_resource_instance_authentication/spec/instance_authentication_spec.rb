require File.join(File.dirname(__FILE__), "/../lib/active_resource_instance_authentication")
%w{rubygems
   activeresource}.each {|file| require file}

require File.join(File.dirname(__FILE__), "/../init")

describe ActiveResource, "- with this module mixed in, and finding -" do
  before :all do
    class Thing < ActiveResource::Base
      self.site = "http://localhost:12345"
    end
  end
  # normal find behavior remains the same
  it "authenticates by class connection" do
    Thing.connection.should_receive(:get).with("/things/1.xml", {}).and_return({})
    Thing.find(1)
  end
  # new find behavior works as desired
  it "authenticates with an arbitrary connection" do
    http_connection = ActiveResource::Connection.new("http://localhost:67890")
    http_connection.should_receive(:get).with("/things/1.xml", {}).and_return({})
    Thing.find(:id => 1, :connection => http_connection)
  end
end

describe ActiveResource, "- with this module mixed in, and saving -" do
  before :all do
    class Thing < ActiveResource::Base
      self.site = "http://localhost:12345"
    end
    @xml = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<thing>\n</thing>\n"
    @response = {'Location' => '/things/1.xml',
                 'Content-Type' => 'application/xml'}
    class << @response
      def body
        {:foo => "bar"}.to_xml(:root => "thing")
      end
    end
  end
  it "saves in the usual way" do
    Thing.connection.should_receive(:post).with("/things.xml", @xml, {}).and_return(@response)
    Thing.new.save
  end
  it "saves with an arbitrary connection" do
    @thing = Thing.new
    @thing.connection = ActiveResource::Connection.new("http://localhost:67890")
    @thing.connection.should_receive(:post).with("/things.xml", @xml, {}).and_return(@response)
    @thing.save
  end
end
