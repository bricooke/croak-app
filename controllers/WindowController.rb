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
  ib_outlet :gear_button
  
  def awakeFromNib
    @status_item = NSStatusBar.systemStatusBar.statusItemWithLength(27.0)
    @status_item.setImage(NSImage.imageNamed("grey_frog"))
    @status_item.setTarget(self)
    @status_item.setAction(:toggle_croaks)
    
    @errors_table_view.setTarget(self)
    @errors_table_view.setDoubleAction(:viewErrorOnWeb)
  end
  
  def toggle_croaks(sender)
    if @window.isVisible
      @window.orderOut(nil)
    else
      @status_item.setImage(NSImage.imageNamed("grey_frog"))
      @window.makeKeyAndOrderFront(nil)
      NSApplication.sharedApplication.activateIgnoringOtherApps(true)
      @errors_table_view.setNeedsDisplay(true)
    end
  end
  
  def go_green(sender)
    NSSound.soundNamed(NSUserDefaults.standardUserDefaults.stringForKey(ApplicationController::PREF_SOUND)).play unless NSUserDefaults.standardUserDefaults.boolForKey(ApplicationController::PREF_SHOULD_PLAY_SOUND) == false
    @status_item.setImage(NSImage.imageNamed("green_frog")) unless @window.isVisible
  end
  
  def showErrors
    @errors_scroll_view.setHidden(false)
    
    @progress.stopAnimation(self)
    @progress.setHidden(true)
    @loading_text.setHidden(true)
    
    @window.makeFirstResponder(@errors_table_view)
  end
  
  def viewErrorOnWeb(sender)
    err = @croak_controller.error(@errors_table_view.selectedRow)
    
    return if err.nil?
    
    NSWorkspace.sharedWorkspace.openURL(NSURL.URLWithString("http://#{err[:domain]}.hoptoadapp.com/errors/#{err[:id]}"));
    toggle_croaks(self)
  end
  
  ib_action :refresh do
    begin # thread
      @croak_controller.refresh_errors
    end
  end
  
  ib_action :show_about do
    @about ||= AboutController.alloc.initWithWindowNibName("About")
    
    NSApp.beginSheet_modalForWindow_modalDelegate_didEndSelector_contextInfo_(
      @about.window,
      @window,
      self,
      nil,
      nil)
  end
end
