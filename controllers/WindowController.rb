#
#  WindowController.rb
#  Croak
#
#  Created by Brian Cooke on 8/22/08.
#  Copyright (c) 2008 roobasoft, LLC. All rights reserved.
#

class WindowController < NSObject
  ib_outlet :window, :croak_controller
  ib_outlet :errors_scroll_view, :errors_table_view
  ib_outlet :progress, :loading_text

  def awakeFromNib
    @status_item = NSStatusBar.systemStatusBar.statusItemWithLength(27.0)
    @status_item.setImage(NSImage.imageNamed("grey_frog"))
    @status_item.setTarget(self)
    @status_item.setAction(:toggle_croaks)
    
    @sound_name = NSUserDefaults.standardUserDefaults.stringForKey("alert_sound") || "Frog"
  end
  
  def toggle_croaks(sender)
    if @window.isVisible
      @window.orderOut(nil)
    else
      @status_item.setImage(NSImage.imageNamed("grey_frog"))
      @window.makeKeyAndOrderFront(nil)
      NSApplication.sharedApplication.activateIgnoringOtherApps(true)
    end
  end
  
  def go_green(sender)
    NSSound.soundNamed(@sound_name).play unless @sound_name == "none"
    @status_item.setImage(NSImage.imageNamed("green_frog"))
  end
  
  def showErrors
    @errors_scroll_view.setHidden(false)
    
    @progress.stopAnimation(self)
    @progress.setHidden(true)
    @loading_text.setHidden(true)
    
    @window.makeFirstResponder(@errors_table_view)
  end
end
