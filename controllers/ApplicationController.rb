class ApplicationController < NSObject
  ib_outlet :window, :croak_controller
  
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
      @croak_controller.refresh_errors
    end
      
        # 
        # keychainItem = EMKeychainProxy.sharedProxy.genericKeychainItemForService_withUsername_("EC2Mgr AWS Identity", username);
        # 
        # if username.nil? || keychainItem.nil?
        #   # ask
        #   aws_ident_vc = AWSIdentitySheetController.alloc.initWithWindowNibName("AWSIdentity")
        #   
        #   NSApp.beginSheet_modalForWindow_modalDelegate_didEndSelector_contextInfo_(
        #     aws_ident_vc.window,
        #     self.window,
        #     self,
        #     "awsIndentitySheetDidEndSelector",
        #     nil)
        # else
        #   # load running instances
        #   Thread.new do 
        #     @ec2 = RightAws::Ec2.new(username, keychainItem.password)
        #     @ec2.describe_images_by_owner('self').each do |image|
        #       puts image.keys
        #       @running_instances_array_controller.addObject(Image.alloc.initWithHash(image))
        #     end
        #   end
        # end
    
  end
  
  def hoptoadSheetDidEndSelector(sheet, returnCode, context)
    return if returnCode == NSCancelButton
  end
end