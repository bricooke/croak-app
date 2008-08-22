#
#  WindowController.rb
#  Croak
#
#  Created by Brian Cooke on 8/22/08.
#  Copyright (c) 2008 roobasoft, LLC. All rights reserved.
#

class WindowController < NSObject
  ib_outlet :window, :croak_controller
  
  def awakeFromNib
    @status_item = NSStatusBar.systemStatusBar.statusItemWithLength(27.0)
    @status_item.setImage(NSImage.imageNamed("grey_frog"))
    @status_item.setTarget(self)
    @status_item.setAction(:toggle_croaks)
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
    @status_item.setImage(NSImage.imageNamed("green_frog"))
  end
end
