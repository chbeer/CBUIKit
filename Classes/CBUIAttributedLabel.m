//
//  CBUIAttributedLabel.m
//  CBUIKit
//
//  Created by Christian Beer on 28.06.11.
//  Copyright 2011 Christian Beer. All rights reserved.
//

#import "CBUIAttributedLabel.h"

NSString * const kCBCTHighlightedForegroundColorAttributeName = @"CBCTHighlightedForegroundColorAttributeName";
NSString * const kCBCTDefaultForegroundColorAttributeName = @"CBCTDefaultForegroundColorAttributeName";


@implementation CBUIAttributedLabel
{
    NSMutableAttributedString *_attributedText;
}

@synthesize attributedText = _attributedText;

@synthesize verticalAlignment = _verticalAlignment;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) return nil;
    
    self.verticalAlignment = VerticalAlignmentMiddle;
    
    return self;
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (!self) return nil;
    
    self.verticalAlignment = VerticalAlignmentMiddle;
    
    return self;
}

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

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    
    if (_attributedText) {
        UIColor *currentColor = highlighted ? [self textColor] : [self highlightedTextColor];
        UIColor *targetColor = highlighted ? [self highlightedTextColor] : [self textColor];
        
        [_attributedText enumerateAttributesInRange:NSMakeRange(0, _attributedText.length) options:0
                                         usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop) {
                                             UIColor *textColor = [attrs objectForKey:(id)kCTForegroundColorAttributeName];
                                             
                                             UIColor *myTargetColor = nil;
                                             
                                             if (!textColor || [currentColor isEqual:textColor]) {
                                                 myTargetColor = targetColor;
                                             } else {
                                                 myTargetColor = [attrs objectForKey:highlighted ? kCBCTHighlightedForegroundColorAttributeName : kCBCTDefaultForegroundColorAttributeName];
                                             }
                                             
                                             if (myTargetColor) {
                                                 [_attributedText addAttribute:(id)kCTForegroundColorAttributeName value:myTargetColor range:range];
                                             }
                                         }];
        
        if (_framesetter) CFRelease(_framesetter);
        _framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)_attributedText);
    }
    
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
        
        CGPoint origin = bounds.origin;
        switch (self.textAlignment) {
            case UITextAlignmentCenter:
                origin.x = ceilf((self.bounds.size.width - size.width) / 2);
                break;
            case UITextAlignmentRight:
                origin.x = ceilf(self.bounds.size.width - size.width);
                break;
            default:
                break;
        }
        
        textRect.origin = origin;
        textRect.size = size;
    }
    switch (self.verticalAlignment) {
        case VerticalAlignmentTop:
            textRect.origin.y = 0;
            break;
        case VerticalAlignmentBottom:
            textRect.origin.y = bounds.size.height - textRect.size.height;
            break;
        case VerticalAlignmentMiddle:
            // Fall through.
        default:
            textRect.origin.y = ceilf((bounds.size.height - textRect.size.height) / 2.0);
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

    if (!_framesetter) return;
    
    actualRect.origin.y = self.bounds.size.height - actualRect.size.height;
    
    CGPathRef path = CGPathCreateWithRect(actualRect, NULL);
    
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
            _attributedText = [inText mutableCopy];
            
            if (_framesetter) CFRelease(_framesetter);
            _framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)_attributedText);
        }
        
        [self setNeedsDisplay];
    }
}

- (CGSize)sizeThatFits:(CGSize)size
{
    if (!self.attributedText) {
        return [super sizeThatFits:size];
    } else {
        CGSize suggestedSize = CTFramesetterSuggestFrameSizeWithConstraints(_framesetter, CFRangeMake(0, 0), NULL, CGSizeMake(size.width, size.height), NULL);
        return suggestedSize;
    }
}

+ (CGSize) sizeOfAttributedString:(NSAttributedString*)attributedText thatFits:(CGSize)size
{
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attributedText);
    CGSize suggestedSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, 0), NULL, CGSizeMake(size.width, size.height), NULL);
    CFRelease(framesetter);
    return suggestedSize;
}

@end
