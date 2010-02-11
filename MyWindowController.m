/*
 
 MyWindowController.m
 vidfreaker screen saver for os 10.6
 
 The MIT License
 
 Copyright (c) 2010 Noah Paessel
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 */

#import "MyWindowController.h"

@implementation MyWindowController

- (IBAction)donePressed:(id)sender
{
	[NSApp endSheet: [self window] returnCode: NSOKButton];
}

- (void) awakeFromNib {
	//[super awakeFromNib];
	
	ScreenSaverDefaults *userPrefs;
	userPrefs = [ScreenSaverDefaults defaultsForModuleWithName:@"vidfreaker-saver"];
	moviePathName = [userPrefs objectForKey: @"moviePath"];	
	if (nil == moviePathName) {
		moviePathName =[ NSHomeDirectory() stringByAppendingPathComponent:@"Movies"];
		[userPrefs setObject:moviePathName forKey:@"moviePath"];
		[userPrefs synchronize];
	}
	[moviePathName retain];
	[label setStringValue:moviePathName];
}

- (IBAction)selectPressed:(id)sender
{ 
	int result;
	NSString *path = nil;
    NSOpenPanel *oPanel = [NSOpenPanel openPanel];
    [oPanel setAllowsMultipleSelection:NO];
	[oPanel setCanChooseDirectories:YES];
	[oPanel setCanChooseFiles:NO];
    result = [oPanel runModalForDirectory:moviePathName
									 file:nil];
    if (result == NSOKButton) {
		path = [oPanel directory];
    }
	moviePathName = path;
	[label setStringValue:moviePathName];
	[self checkFolder];
	ScreenSaverDefaults *userPrefs;
	userPrefs = [ScreenSaverDefaults defaultsForModuleWithName:@"vidfreaker-saver"];
	[userPrefs setValue:moviePathName forKey: @"moviePath"];
	[userPrefs synchronize];
}

- (NSString *) moviePathName {
	return moviePathName;
}

- (void) checkFolder {
	
	NSDirectoryEnumerator *direnum = [[NSFileManager defaultManager] enumeratorAtPath:moviePathName];
	NSString *pname;
	int count = 0;
	
	NSArray *ourTypes = [ NSArray arrayWithObjects:@"mov",@"avi",@"mpeg",@"mp4",@"MOV",@"AVI",@"MPEG",@"mpg",@"MPG", nil];
	while (pname = [direnum nextObject]) {
		if ([ourTypes  containsObject:[pname pathExtension]]) {
			count++;
		}
	}
	
	if (count < 1) {
		NSString *message = @"No movie files were found in the directory you specified.";
		NSString *extendedMessage = 
@"video freaker will not be able to montage your movies unless \
you provide a folder containing at least one movie.\
Video Freaker can read AVI, MOV and MPEG files at this time.";
		
		NSAlert *alert = [NSAlert alertWithMessageText:message
										 defaultButton:@"ok" 
									   alternateButton:nil 
										   otherButton:nil 
							 informativeTextWithFormat:extendedMessage];
		[alert runModal];
	}
	
}


@end
