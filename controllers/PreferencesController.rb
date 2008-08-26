#
#  PreferencesController.rb
#  Croak
#
#  Created by Brian Cooke on 8/25/08.
#  Copyright (c) 2008 roobasoft, LLC. All rights reserved.
#
class PreferencesController < OSX::NSWindowController
  ib_outlet :should_make_sound_checkbox, :sounds_popup, :refresh_popup
  
  def init
    initWithWindowNibName("Preferences")
    self
  end
  
  def awakeFromNib
    @should_make_sound_checkbox.setTextColor(NSColor.whiteColor)
    NSLog(NSUserDefaults.standardUserDefaults.objectForKey(ApplicationController::PREF_REFRESH_SECONDS).integerValue.to_s)
    @refresh_popup.selectItemWithTag(NSUserDefaults.standardUserDefaults.objectForKey(ApplicationController::PREF_REFRESH_SECONDS).integerValue.to_s)
  end
  
  def sounds
    NSSound.availableSounds
  end
  
  ib_action :refresh_popup_changed do |sender|
    value = @refresh_popup.selectedItem.tag.to_i
    NSUserDefaults.standardUserDefaults.setObject_forKey(NSNumber.numberWithInt(value), ApplicationController::PREF_REFRESH_SECONDS)
  end
end
