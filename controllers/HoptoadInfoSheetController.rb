#
#  HoptoadInfoSheetController.rb
#  EC2Mgr
#
#  Created by Brian Cooke on 8/23/08.
#  Copyright (c) 2008 roobasoft, LLC. All rights reserved.
#

class HoptoadInfoSheetController < NSWindowController
  ib_outlet :domain, :auth_token
  
  ib_action :cancel do |sender|
    self.window.close
    NSApp.endSheet_returnCode_(self.window, NSCancelButton)
  end
  
  ib_action :save do
    # make sure it works
    # Spinner!
    Thread.new do 
      h = HoptoadInfo.create({
        :domain => self.domain,
        :auth_token => self.auth_token
      })
      
      @domain.setStringValue("Thinking...")

      if h.save
        self.window.close
        NSApp.endSheet_returnCode_(self.window, NSOKButton)
      else
        @domain.setStringValue("ERROR!")
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
