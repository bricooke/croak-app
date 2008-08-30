#
#  HoptoadInfoSheetController.rb
#  EC2Mgr
#
#  Created by Brian Cooke on 8/23/08.
#  Copyright (c) 2008 roobasoft, LLC. All rights reserved.
#

class HoptoadInfoSheetController < NSWindowController
  ib_outlet :domain, :auth_token, :progress, :cancel, :save, :error_label
  
  ib_action :cancel do |sender|
    self.window.close
    NSApp.endSheet_returnCode_(self.window, NSCancelButton)
  end
  
  ib_action :save do
    # make sure it works
    Thread.new do 
      @error_label.setStringValue("")
      
      [@domain, @auth_token, @cancel, @save].each do |control|
        control.setEnabled(false)
      end
      @progress.startAnimation(self)
      @progress.setHidden(false)
      
      h = HoptoadInfo.create({
        :domain => self.domain,
        :auth_token => self.auth_token
      })
      
      if h.save
        self.window.close
        NSApp.endSheet_returnCode_(self.window, NSOKButton)
      else
        @error_label.setStringValue("Invalid domain or auth token.")
        @progress.setHidden(true)
        [@auth_token, @domain, @cancel, @save].each do |control|
          control.setEnabled(true)
        end
      end
    end
  end
  
  def domain
    @domain.stringValue.strip
  end
  
  def auth_token
    @auth_token.stringValue.strip
  end
end
