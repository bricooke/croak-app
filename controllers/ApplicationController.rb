#
#  ApplicationController.rb
#  Croak
#
#  Created by Brian Cooke on 8/22/08.
#  Copyright (c) 2008 roobasoft, LLC. All rights reserved.
#

class ApplicationController < NSObject
  PREF_SHOULD_PLAY_SOUND = "shouldPlaySound"
  PREF_SOUND = "sound"
  
  ib_outlet :window, :croak_controller
  
  def initialize
    defaults = NSMutableDictionary.dictionary
    defaults.setObject_forKey(NSNumber.numberWithBool(true), PREF_SHOULD_PLAY_SOUND)
    defaults.setObject_forKey("Frog", PREF_SOUND)
    NSUserDefaults.standardUserDefaults.registerDefaults(defaults)
  end
  
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
  
  ib_action :show_preferences do |sender|
    @preferences_controller ||= PreferencesController.alloc.init
    @preferences_controller.showWindow(self)
  end
  
  
end