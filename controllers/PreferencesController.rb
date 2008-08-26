#
#  PreferencesController.rb
#  Croak
#
#  Created by Brian Cooke on 8/25/08.
#  Copyright (c) 2008 roobasoft, LLC. All rights reserved.
#
class PreferencesController < OSX::NSWindowController
  ib_outlet :should_make_sound_checkbox, :sounds_popup
  
  def init
    initWithWindowNibName("Preferences")
    self
  end
  
  def awakeFromNib
    @should_make_sound_checkbox.setTextColor(NSColor.whiteColor)
  end
  
  def sounds
    NSSound.availableSounds
  end
end
