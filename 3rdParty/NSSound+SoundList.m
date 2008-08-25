/*
 Copyright (c) 2006 Michael Bianco, <software@mabwebdesign.com>
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), 
 to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, 
 and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, 
 INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, 
 DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, 
 ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#import "NSSound+SoundList.h"

// code adapted from: http://www.cocoabuilder.com/archive/message/cocoa/2005/10/27/148962

#define SystemLibrary() @"/System/Library/"
#define AllUsersLibrary() @"/Library/"
#define UserLibrary() [NSHomeDirectory() stringByAppendingPathComponent:@"Library/"]
#define SoundsDirectory(base) [base stringByAppendingPathComponent:@"Sounds"]

static NSArray *SLSoundList = nil;

@implementation NSSound (SoundList)
+ (NSArray *) availableSounds {
	if(!SLSoundList) {
		NSMutableArray *tempList = [NSMutableArray array];
		
		NSArray *knownSoundTypes = [NSSound soundUnfilteredFileTypes];
		NSArray *searchPaths = [NSArray arrayWithObjects:SoundsDirectory(SystemLibrary()), SoundsDirectory(AllUsersLibrary()), SoundsDirectory(UserLibrary()), nil];
		NSString *soundDirectory, *soundFile;
		NSEnumerator *dirEnum = [searchPaths objectEnumerator], *fileEnum;
		NSFileManager *fm = [NSFileManager defaultManager];
		BOOL isDir;
		
		while (soundDirectory = [dirEnum nextObject]) {
			if([fm fileExistsAtPath:soundDirectory isDirectory:&isDir]) {
				if(isDir) {
					fileEnum = [[fm directoryContentsAtPath:soundDirectory] objectEnumerator];
					
					while (soundFile = [fileEnum nextObject]) {
						if ([knownSoundTypes containsObject:[soundFile pathExtension]]) {
							[tempList addObject:[soundFile stringByDeletingPathExtension]];
						}
					}
				}
			}
		}

		SLSoundList = [[tempList sortedArrayUsingSelector:@selector(compare:)] retain];
	}
	
	return SLSoundList;
}
@end
