#
#  ApplicationController.rb
#  Croak
#
#  Created by Brian Cooke on 8/22/08.
#  Copyright (c) 2008 roobasoft, LLC. All rights reserved.
#

class ApplicationController < NSObject
  ib_outlet :window, :croak_controller
  
  def applicationDidFinishLaunching(notification)
    domains = HoptoadInfo.find
    
    if domains.nil? || domains.empty?
      # ask for one
      @hisc ||= HoptoadInfoSheetController.alloc.initWithWindowNibName("HoptoadInfoSheet")
      
      NSApp.beginSheet_modalForWindow_modalDelegate_didEndSelector_contextInfo_(
        @hisc.window,
        @window,
        self,
        "hoptoadSheetDidEndSelector",
        nil)
    else
      @croak_controller.refresh_errors
    end
  end
  
  def hoptoadSheetDidEndSelector(sheet, returnCode, context)
    return if returnCode == NSCancelButton
  end
end