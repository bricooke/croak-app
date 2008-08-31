#
#  HoptoadInfoSheetController.rb
#  EC2Mgr
#
#  Created by Brian Cooke on 8/23/08.
#  Copyright (c) 2008 roobasoft, LLC. All rights reserved.
#

class HoptoadInfoSheetController < NSWindowController
  ib_outlet :domain_text_field, :auth_token_text_field, :progress, :cancel, :save, :error_label
  kvc_accessor :auth_token, :domain
  
  ib_action :cancel do |sender|
    self.window.close
    NSApp.endSheet_returnCode_(self.window, NSCancelButton)
  end
  
  ib_action :save do
    @auth_token_text_field.selectText(self) #forces end editing and forces KVC update (workaround)
    
    # make sure it works
    Thread.new do 
      h = HoptoadInfo.create({
        :domain => domain.strip,
        :auth_token => auth_token.strip
      })
      
      @error_label.setStringValue("")
      
      [@domain_text_field, @auth_token_text_field, @cancel, @save].each do |control|
        control.setEnabled(false)
      end
      @progress.startAnimation(self)
      @progress.setHidden(false)
      
      if h.save
        self.window.close
        NSApp.endSheet_returnCode_(self.window, NSOKButton)
      else
        @error_label.setStringValue("Invalid domain or auth token.")
        @progress.setHidden(true)
        [@auth_token_text_field, @domain_text_field, @cancel, @save].each do |control|
          control.setEnabled(true)
        end
      end
    end
  end
end
