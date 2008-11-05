#
#  CroakCell.rb
#  Croak
#
#  Created by Brian Cooke on 8/21/08.
#  Copyright (c) 2008 roobasoft, LLC. All rights reserved.
#
class CroakCell < NSTextFieldCell
  # TODO: Cleanup into something sensible :P
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
    
    font = NSFont.systemFontOfSize(14)
    attrsDictionary = NSDictionary.dictionaryWithObjects_forKeys(NSArray.arrayWithObjects(font, NSColor.whiteColor, nil), NSArray.arrayWithObjects(NSFontAttributeName, NSForegroundColorAttributeName, nil))

    error = objectValue

    if isKeyAndHighlighted
      NSColor.blackColor.set
      NSBezierPath.fillRect(bounds)
      
      NSColor.colorWithDeviceRed_green_blue_alpha(0.73, 0.73, 0.73, 1.0).set
      b = NSBezierPath.bezierPathWithRoundedRect_xRadius_yRadius(bounds, 3.0, 3.0)
      b.stroke
      
      NSColor.colorWithDeviceRed_green_blue_alpha(0.15, 0.15, 0.15, 1.0).set
      b.fill
    end
    
    bounds.y += 3
    bounds.height -= 3
    bounds.x += 3
    bounds.width -= 3
    
    titleRect = NSMakeRect(bounds.x, bounds.y, bounds.width, bounds.height)
    titleRect.height -= 15
    titleRect.width -= 64
    
    title = NSAttributedString.alloc.initWithString_attributes(error[:error_message], attrsDictionary)
    if title.length > 0
      title.drawInRect(titleRect)
    end
    
    # draw the time this happened
    font = NSFont.systemFontOfSize(12)
    attrsDictionary = NSDictionary.dictionaryWithObjects_forKeys(NSArray.arrayWithObjects(font, NSColor.whiteColor, nil), NSArray.arrayWithObjects(NSFontAttributeName, NSForegroundColorAttributeName, nil))
    last_notice_bounds = NSMakeRect(bounds.x, bounds.y, bounds.width, bounds.height)
    last_notice_bounds.y += last_notice_bounds.height - 16
    last_notice_bounds.width -= 3
    
    dateFormatter = NSDateFormatter.alloc.init
    dateFormatter.setDateStyle(NSDateFormatterMediumStyle)
    dateFormatter.setTimeStyle(NSDateFormatterMediumStyle)
    formatted_date = dateFormatter.stringFromDate(error[:most_recent_notice_at]).to_s
    
    last_notice_at = Error.fuzzy_last_notice_at(Time.parse(formatted_date))
    attrString = NSMutableAttributedString.alloc.initWithString_attributes(last_notice_at, attrsDictionary)
    attrString.setAlignment_range(NSRightTextAlignment, NSMakeRange(0, last_notice_at.length))
    attrString.drawInRect(last_notice_bounds)

    error_file_bounds = last_notice_bounds
    error_file_bounds.width -= 50
    attrString = NSMutableAttributedString.alloc.initWithString_attributes(error[:file] + ":" + error[:line_number], attrsDictionary)
    attrString.drawInRect(error_file_bounds)
    

    # draw the notice count
    notice_count_bounds = NSMakeRect(bounds.x, bounds.y, bounds.width, bounds.height)
    notice_count_bounds.x += (notice_count_bounds.width - 60)
    notice_count_bounds.width = 50
    notice_count_bounds.height = 30
    
    NSColor.colorWithDeviceRed_green_blue_alpha(36.9/100.0, 54.5/100.0, 19.6/100.0, 1.0).set
    NSBezierPath.bezierPathWithRoundedRect_xRadius_yRadius(notice_count_bounds, 3.0, 3.0).fill

    font = NSFont.boldSystemFontOfSize(24)
    attrsDictionary = NSDictionary.dictionaryWithObjects_forKeys(NSArray.arrayWithObjects(font, NSColor.whiteColor, nil), NSArray.arrayWithObjects(NSFontAttributeName, NSForegroundColorAttributeName, nil))
    attrString = NSMutableAttributedString.alloc.initWithString_attributes(error[:notices_count].to_s, attrsDictionary)
    attrString.setAlignment_range(NSCenterTextAlignment, NSMakeRange(0, error[:notices_count].to_s.size))
    attrString.drawInRect(notice_count_bounds)
    

    # attrString = NSAttributedString.alloc.initWithString_attributes(error[:file] + ":" + error[:line_number], attrsDictionary)
    # attrString.drawInRect(titleRect)
  end
  
  def expansionFrameWithFrame_inView(cellFrame, view)
    NSZeroRect
  end
end
