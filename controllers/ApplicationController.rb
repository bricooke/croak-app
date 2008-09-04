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
  PREF_REFRESH_SECONDS = "refreshInSeconds"
  
  ib_outlet :window, :croak_controller
  
  attr_accessor :growl
  
  def initialize
    defaults = NSMutableDictionary.dictionary
    defaults.setObject_forKey(NSNumber.numberWithBool(true), PREF_SHOULD_PLAY_SOUND)
    defaults.setObject_forKey("Frog", PREF_SOUND)
    defaults.setObject_forKey(NSNumber.numberWithInt(300), PREF_REFRESH_SECONDS)
    NSUserDefaults.standardUserDefaults.registerDefaults(defaults)
    
    # register with growl (rawr)
    @growl = GrowlNotifier.new('Croak',['New error'], nil, NSImage.imageNamed("Croak"))
    @growl.register()
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
      show_errors
    end
  end
  
  def hoptoadSheetDidEndSelector(sheet, returnCode, context)
    return if returnCode == NSCancelButton
    show_errors
  end
  
  def show_errors(timer = nil, user_info = nil)
    begin # thread
      NSLog("Refreshing...")
      @croak_controller.refresh_errors
      
      NSTimer.scheduledTimerWithTimeInterval_target_selector_userInfo_repeats(
        NSUserDefaults.standardUserDefaults.objectForKey( ApplicationController::PREF_REFRESH_SECONDS).integerValue,
        self,
        "show_errors",
        nil,
        false
      )
    end
  end
  
  ib_action :show_preferences do |sender|
    @preferences ||= PreferencesController.alloc.initWithWindowNibName("Preferences")
    
    NSApp.beginSheet_modalForWindow_modalDelegate_didEndSelector_contextInfo_(
      @preferences.window,
      @window,
      self,
      nil,
      nil)
  end
end