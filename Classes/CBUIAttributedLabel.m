//
//  CBUIAttributedLabel.m
//  CBUIKit
//
//  Created by Christian Beer on 28.06.11.
//  Copyright 2011 Christian Beer. All rights reserved.
//

#import "CBUIAttributedLabel.h"
#import <CoreText/CoreText.h>

@implementation CBUIAttributedLabel

@dynamic text;

- (void)dealloc {
    [text release];
    [super dealloc];
}

#pragma mark UIView

- (void)drawRect:(CGRect)rect
{
    if (!text) return;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    
    // Set the usual "flipped" Core Text draw matrix
	CGContextTranslateCTM(context, 0, ([self bounds]).size.height );
	CGContextScaleCTM(context, 1.0, -1.0);
    
/*    CTLineRef line = CTLineCreateWithAttributedString(text);
    
    // Set text position and draw the line into the graphics context
    CGContextSetTextPosition(context, 0.0, 0.0);
    CTLineDraw(line, context);
    CFRelease(line);*/
    
    CGPathRef path = CGPathCreateWithRect(self.bounds, NULL);
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)text);
    if (!framesetter) return;
    
    // Create the frame and draw it into the graphics context
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter,
                                                CFRangeMake(0, 0), path, NULL);
    
    if (framesetter) CFRelease(framesetter);
    
    CTFrameDraw(frame, context);
    
    if (path) CFRelease(path);
    if (frame) CFRelease(frame);
}

#pragma mark - Acccessors

- (NSAttributedString*)text
{
    return text;
}
- (void) setText:(NSAttributedString*)inText {
    if (inText != text) {
        [text release];
        
        if ([inText isKindOfClass:[NSString class]]) {
            text = [[NSAttributedString alloc] initWithString:(NSString*)inText];
        } else {
            text = [inText copy];
        }
        
        [self setNeedsDisplay];
    }
}

@end
