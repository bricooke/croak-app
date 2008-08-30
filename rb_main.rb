#
#  rb_main.rb
#  Croak
#
#  Created by Brian Cooke on 8/21/08.
#  Copyright (c) 2008 roobasoft, LLC. All rights reserved.
#

require 'osx/cocoa'
require 'rubygems'

include OSX

Thread.abort_on_exception = true

%w(EMKeychainProxy EMKeyChainItem).each do |class_name|
  OSX.ns_import class_name.to_sym
end

gemdir = OSX::NSBundle.mainBundle.resourcePath.stringByAppendingPathComponent("gems").fileSystemRepresentation
Dir.glob(File.join("#{gemdir}/**/lib")).each do |path|
  $:.unshift(gemdir, path)
end

def rb_main_init  
  path = OSX::NSBundle.mainBundle.resourcePath.fileSystemRepresentation
  rbfiles = Dir.entries(path).select {|x| /\.rb\z/ =~ x}
  rbfiles -= [ File.basename(__FILE__) ]
  rbfiles.each do |path|
    next if File.basename(path) == "Error.rb" # save that guy for later (takes too long to load)
    require( File.basename(path) )
  end
end

if $0 == __FILE__ then
  rb_main_init
  OSX.NSApplicationMain(0, nil)
end
