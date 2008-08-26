// Via http://www.pastebuffer.com/2007/10/04/setting-the-text-color-of-an-nsbutton/

#import <Cocoa/Cocoa.h>
@interface NSButton (TextColor)

- (NSColor *)textColor;
- (void)setTextColor:(NSColor *)textColor;

@end

