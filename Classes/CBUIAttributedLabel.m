//
//  CBUIAttributedLabel.m
//  CBUIKit
//
//  Created by Christian Beer on 28.06.11.
//  Copyright 2011 Christian Beer. All rights reserved.
//

#import "CBUIAttributedLabel.h"


@implementation CBUIAttributedLabel

@synthesize attributedText = _attributedText;

@synthesize verticalAlignment = _verticalAlignment;

- (void)dealloc {
    self.attributedText = nil;
    if (_framesetter) CFRelease(_framesetter);
    [super dealloc];
}

#pragma mark UILabel

- (void)setVerticalAlignment:(VerticalAlignment)verticalAlignment {
    _verticalAlignment = verticalAlignment;
    [self setNeedsDisplay];
}

- (CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines {
    CGRect textRect = bounds;
    if (!self.attributedText) {
        textRect = [super textRectForBounds:bounds limitedToNumberOfLines:numberOfLines];
    } else {
        CFRange range = CFRangeMake(0, self.attributedText.length);
        CFRange fitRange;
        
        CGSize size = CTFramesetterSuggestFrameSizeWithConstraints(_framesetter, range, nil, bounds.size, &fitRange);
        
        textRect.origin = bounds.origin;
        textRect.size = size;
    }
    switch (self.verticalAlignment) {
        case VerticalAlignmentTop:
            textRect.origin.y = bounds.origin.y + bounds.size.height - textRect.size.height;
            break;
        case VerticalAlignmentBottom:
            textRect.origin.y = bounds.origin.y;
            break;
        case VerticalAlignmentMiddle:
            // Fall through.
        default:
            textRect.origin.y = bounds.origin.y + (bounds.size.height - textRect.size.height) / 2.0;
    }
    return textRect;
}

- (void)drawTextInRect:(CGRect)requestedRect
{
    CGRect actualRect = [self textRectForBounds:requestedRect
                         limitedToNumberOfLines:self.numberOfLines];

    if (!self.attributedText) {
        [super drawTextInRect:actualRect];
        return;   
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    
    // Set the usual "flipped" Core Text draw matrix
	CGContextTranslateCTM(context, 0, ([self bounds]).size.height );
	CGContextScaleCTM(context, 1.0, -1.0);
    
    CGPathRef path = CGPathCreateWithRect(actualRect, NULL);
    
    if (!_framesetter) return;
    
    // Create the frame and draw it into the graphics context
    CTFrameRef frame = CTFramesetterCreateFrame(_framesetter, CFRangeMake(0, 0), path, NULL);
    
    CTFrameDraw(frame, context);
    
    if (path) CFRelease(path);
    if (frame) CFRelease(frame);
}

#pragma mark - Acccessors

- (void) setAttributedText:(NSAttributedString*)inText {
    if (inText != _attributedText) {
        [_attributedText release];
        
        if ([inText isKindOfClass:[NSString class]]) {
            [self setText:(NSString*)inText];
        } else {
            _attributedText = [inText copy];
            _framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)_attributedText);
        }
        
        [self setNeedsDisplay];
    }
}

@end
