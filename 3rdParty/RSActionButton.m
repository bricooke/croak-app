//
//  RSActionButton.m
//  rooSwitch
//
//  Created by Brian Cooke on 3/24/06.
//  Copyright 2006 roobasoft, LLC. All rights reserved.
//

#import "RSActionButton.h"


@implementation RSActionButton


-(void)mouseDown:(NSEvent *)theEvent 
{
    [self highlight:YES];
    
    NSPoint point = [self convertPoint:[self bounds].origin toView:nil];
	point.y -= NSHeight( [self frame] );
	
	NSEvent *event = [NSEvent mouseEventWithType:[theEvent type] location:point modifierFlags:[theEvent modifierFlags] timestamp:[theEvent timestamp] windowNumber:[[theEvent window] windowNumber] context:[theEvent context] eventNumber:[theEvent eventNumber] clickCount:[theEvent clickCount] pressure:[theEvent pressure]];
	[NSMenu popUpContextMenu:[self menu] withEvent:event forView:self];
    
    [self highlight:NO];
}


@end
