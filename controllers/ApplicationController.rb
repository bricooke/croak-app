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
  
  def show_errors
    Thread.new do
      while true
        begin
          @croak_controller.refresh_errors
          sleep NSUserDefaults.standardUserDefaults.objectForKey( ApplicationController::PREF_REFRESH_SECONDS).integerValue
        rescue Exception => e
          # todo: eat our own dog food and send this to hoptoad?
          # would have to confirm that with the user first.
          NSLog("OH NOES!: #{e} - #{e.message}")
          NSLog(e.backtrace.to_s)
        end
      end
    end
  end
  
  ib_action :show_preferences do |sender|
    @preferences_controller ||= PreferencesController.alloc.init
    @preferences_controller.showWindow(self)
  end
end