#
#  CroakCell.rb
#  Croak
#
#  Created by Brian Cooke on 8/21/08.
#  Copyright (c) 2008 roobasoft, LLC. All rights reserved.
#
class CroakCell < NSTextFieldCell
  def drawInteriorWithFrame_inView(bounds, controlView)
    setFont(NSFont.systemFontOfSize(12))
    
    isKeyAndHighlighted = false
    window = controlView.window
    
    if self.isHighlighted && window.isKeyWindow
      if window.firstResponder == controlView
        isKeyAndHighlighted = true
      elsif controlView.currentEditor != nil && window.firstResponder == controlView.currentEditor
        isKeyAndHighlighted = true
      end
    end
    
    font = NSFont.systemFontOfSize(12)
    attrsDictionary = NSDictionary.dictionaryWithObjects_forKeys(NSArray.arrayWithObjects(font, NSColor.whiteColor, nil), NSArray.arrayWithObjects(NSFontAttributeName, NSForegroundColorAttributeName, nil))

    error = objectValue

    titleRect = bounds
    title = NSAttributedString.alloc.initWithString_attributes(error[:error_message], attrsDictionary)
    if title.length > 0
      title.drawInRect(titleRect)
    end
    
    bounds.y += bounds.height - 16
    attrString = NSAttributedString.alloc.initWithString_attributes(error[:last_notice_at] + " (#{error[:notices_count]})", attrsDictionary)
    attrString.drawInRect(titleRect)
  end
end
