/*

vidfreaker_saverView.h
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

#import <ScreenSaver/ScreenSaver.h>
#import <QTKit/QTKit.h>
#import "MyWindowController.h"

@interface vidfreaker_saverView : ScreenSaverView 
{
	QTMovie		*movie;
	NSSize		movieSize;
	
	NSString	*moviePath;
	
	QTTime		duration;
	
	int			movieWidth;
	int			movieHeight;
	float		alpha;
	
	QTTime		timePointer;
	long		frameCounter;
	
	float		timeAcc;
	
	int			modFrame;
	int			dstX;
	int			dstY;
	float		dstXVel;
	float		dstYVel;
	int			dstSize;
	
	float		srcXVel;
	float		srcYVel;
	float		srcSizeVel;
	
	float		srcX;
	float		srcY;
	float		srcSize;
	


	NSRect		srcBounds;
	NSRect		dstbounds;
	
	NSImage *frameImage;
	NSWindowController *wincontroller;
}

-(void)setMovie;


@end
