#
#  AboutController.rb
#  Croak
#
#  Created by Brian Cooke on 8/30/08.
#  Copyright (c) 2008 roobasoft, LLC. All rights reserved.
#

class AboutController < NSWindowController
  ib_outlet :credits_text_view, :version_label
  
  def awakeFromNib
    @credits_text_view.readRTFDFromFile(NSBundle.mainBundle.pathForResource_ofType("Credits", "rtf"))
    
    infoDotPlist = "#{OSX::NSBundle.mainBundle.resourcePath.fileSystemRepresentation}/../Info.plist"
    plistData = NSData.dataWithContentsOfFile(infoDotPlist);
    format = nil
    error = nil
    plist = NSPropertyListSerialization.propertyListFromData_mutabilityOption_format_errorDescription(plistData, NSPropertyListImmutable.to_i, format, error)
    @version_label.setStringValue("Croak " + plist.valueForKey("CFBundleVersion"))
  end
  
  ib_action :close_window do
    self.window.close
    NSApp.endSheet_returnCode_(self.window, NSCancelButton)
  end
  
end
