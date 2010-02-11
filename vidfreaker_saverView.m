/*
 
 vidfreaker_saverView.m
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

#import "vidfreaker_saverView.h"


@implementation vidfreaker_saverView

- (id)initWithFrame:(NSRect)frame isPreview:(BOOL)isPreview
{
    self = [super initWithFrame:frame isPreview:isPreview];
	
	if (self) {  
		// set some basic values
		dstbounds = frame;
		dstSize = dstbounds.size.width;
		timeAcc = SSRandomIntBetween(-500,500);
		dstXVel = 1.0f;
		dstSize = 1000;
		alpha = 1;
		
		// read prefs
		ScreenSaverDefaults *userPrefs;
		userPrefs = [ScreenSaverDefaults defaultsForModuleWithName:@"vidfreaker-saver"];
		moviePath = [userPrefs stringForKey:@"moviePath"];
		
		// get our movie path
		if (nil == moviePath) {
			moviePath =[ NSHomeDirectory() stringByAppendingPathComponent:@"Movies"];
			[userPrefs setObject:moviePath forKey:@"moviePath"];
			[userPrefs synchronize];
		}
		[moviePath retain];
		
		duration = QTMakeTime(1000, 1);
		
		timePointer = QTMakeTime(500,1);
		
		[self setAnimationTimeInterval:1/120.0];
		[self setMovie];
    }
	return self;
}

- (void) dealloc {
	[movie release];
	movie = nil;
	
	[frameImage release];
	frameImage = nil;
	
	[moviePath release];
	moviePath = nil;
	
	[super dealloc];
}

- (void)startAnimation
{
    [super startAnimation];
}

- (void)stopAnimation
{
    [super stopAnimation];
}

- (void)drawRect:(NSRect)rect
{
    [super drawRect:rect];
	[self animateOneFrame];
}



#pragma mark Movie
// open a Movie File and instantiate a QTMovie object
-(void)setMovie {
	if (nil != movie) {
		[movie release];
		movie = nil;
	}
	
	NSDirectoryEnumerator *direnum = [[NSFileManager defaultManager] enumeratorAtPath:moviePath];
	NSString *pname;
	NSMutableArray *movieFiles = [[NSMutableArray alloc] init];
	
	NSArray *ourTypes = [ NSArray arrayWithObjects:@"mov",@"avi",@"mp4",@"MP4",@"mpeg",@"MOV",@"AVI",@"MPEG",@"mpg",@"MPG", nil];
	while (pname = [direnum nextObject]) {
		if ([ourTypes  containsObject:[pname pathExtension]]) {
			[movieFiles addObject: [moviePath stringByAppendingPathComponent:pname]];
		}
	}
	
	if ([movieFiles count] > 0) {
		NSString *mpath = [movieFiles objectAtIndex: SSRandomIntBetween(0,[movieFiles count]-1)];
		movie = [[QTMovie alloc] initWithFile:mpath error:nil];
	}
	
	if (nil != movie) {
		movieSize = [[movie attributeForKey:@"QTMovieCurrentSizeAttribute"] sizeValue];
		srcSize = movieSize.height;
		[movie retain]; 
		
		duration = [movie duration];
		timePointer = [movie duration];
		timePointer.timeValue = timePointer.timeValue / SSRandomIntBetween(1,10);
	}
	
	// load a default image
	else {
		NSString *imagePath;
		NSBundle *thisBundle = [NSBundle bundleForClass:[self class]];
		if (imagePath = [thisBundle pathForResource:@"notfound" ofType:@"jpg"]) {
			frameImage = [[[NSImage alloc] initWithContentsOfFile:imagePath] retain];
			movieSize = NSMakeSize(400,400);
			srcSize = 400;
		}
	}
	
	modFrame = 10;	
	srcSize = SSRandomIntBetween(10,srcSize);
	timeAcc = SSRandomFloatBetween(-3000.0f,3000.0f);
}


- (void)randomatronics {
	
	int	dstSizeMax = dstbounds.size.width;
	int	dstSizeMin = 100;
	
	int effect = SSRandomIntBetween(1,14);
	switch (effect) {
		case 1:
			if (dstSize<<1 < dstSizeMax) {
				dstSize = dstSize<<1;
			}
			break;
			
		case 2:
			if (dstSize>>1 > dstSizeMin) {
				dstSize = dstSize>>1;
			}
			break;
			
		case 3:
			srcSizeVel += SSRandomFloatBetween(-1.0f,1.0f);
			srcSizeVel = srcSizeVel > 20 ? 20 : srcSizeVel;
			srcSizeVel = srcSizeVel < -20 ? -20 : srcSizeVel;
			break;
			
		case 4:
			dstXVel += SSRandomFloatBetween(-.5f,.5f);
			dstXVel = dstXVel > 4 ? 4 : dstXVel;
			dstXVel = dstXVel < -4 ? -4 : dstXVel;
			break;
			
			
		case 6:
			dstYVel += SSRandomFloatBetween(-0.5f,0.5f);
			dstYVel = dstYVel > 4 ? 4 : dstYVel;
			dstYVel = dstYVel < -4 ? -4 : dstYVel;
			break;
			
			
		case 8:
			srcXVel += SSRandomFloatBetween(-1.0f,1.0f);
			srcXVel = srcXVel > 20 ? 20 : srcXVel;
			srcXVel = srcXVel < -20 ? -20 : srcXVel;
			break;
			
		case 9:
			srcYVel += SSRandomFloatBetween(-1.0f,1.0f);
			srcYVel = srcYVel > 20 ? 20 : srcYVel;
			srcYVel = srcYVel < -20 ? -20 : srcYVel;
			break;
			
		case 10:
			modFrame = SSRandomIntBetween(3,20);
			break;
			
		case 11:
			if (SSRandomIntBetween(0,50) == 1) {
				[self setMovie];
			}
			break;
			
		case 12:
			timeAcc += SSRandomFloatBetween(-5.0f,5.0f);
			timeAcc = timeAcc > 5000 ? 5000 : timeAcc;
			timeAcc = timeAcc < -5000 ? -5000 : timeAcc;
			break;
			
		case 13:
			timeAcc *= SSRandomFloatBetween(-2.0f,2.0f);
			timeAcc = timeAcc > 5000 ? 5000 : timeAcc;
			timeAcc = timeAcc < -5000 ? -5000 : timeAcc;
			break;
			
		case 14:
			alpha += SSRandomFloatBetween(-0.25f,0.25f);
			alpha = alpha > 1.0f ? 1.0f : alpha;
			alpha = alpha < .4f ? 0.4f : alpha;
			break;
	}
	
	// dstSize = dstSizeMax / dstSizeDiv;
	int maxDstX = dstbounds.size.width / dstSize;
	int maxDstY = dstbounds.size.height / dstSize;
	
	srcSize += srcSizeVel;
	srcSize = srcSize > movieSize.height ? movieSize.height : srcSize;
	srcSize = srcSize < 10 ? 10 : srcSize;
	
	timePointer.timeValue += timeAcc;
	timePointer.timeValue = timePointer.timeValue > duration.timeValue ? 0 : timePointer.timeValue;
	timePointer.timeValue = timePointer.timeValue < 0 ? duration.timeValue : timePointer.timeValue;
	frameCounter++;
	frameCounter = frameCounter % modFrame;
	if (frameCounter == 0) {
		if (nil != movie) {
			if (nil != frameImage) {
				[frameImage release];
				frameImage = nil;
			}
			frameImage = [movie frameImageAtTime:timePointer];
			[frameImage retain];
		}
	}
	
	dstX += dstXVel;
	dstY += dstYVel;
	
	srcX += srcXVel;
	srcY += srcYVel;
	
	dstX = dstX > maxDstX ? 0 : dstX;
	dstX = dstX < 0 ? maxDstX : dstX;
	
	dstY = dstY > maxDstY ? 0  : dstY;
	dstY = dstY < 0 ? maxDstY : dstY;
	
	srcX = srcX +srcSize > movieSize.width ? movieSize.width - srcSize : srcX;
	srcX = srcX < 0 ? 0 : srcX;
	
	srcY = srcY + srcSize > movieSize.height ? movieSize.height - srcSize  : srcY;
	srcY = srcY < 0 ? 0 : srcY;
}



- (void)animateOneFrame
{
	[self randomatronics];
	if (nil != frameImage) {
		[frameImage drawInRect:NSMakeRect(dstX * dstSize, dstY * dstSize, dstSize,dstSize) 
					  fromRect:NSMakeRect(srcX,srcY,srcSize,srcSize) 
					 operation:NSCompositeSourceOver  
					  fraction:alpha];
	}
	
    return;
}


- (BOOL)hasConfigureSheet
{
    return YES;
}

- (NSWindow*)configureSheet
{
	NSWindow *returnWindow;
	if (wincontroller == nil) {
		wincontroller = [[MyWindowController alloc]initWithWindowNibName:@"prefswindow"];
		[wincontroller retain];
		[wincontroller loadWindow];
	}
	
	returnWindow = [wincontroller window];
	return returnWindow;
}


@end
