//
//  CBUIAttributedLabel.m
//  CBUIKit
//
//  Created by Christian Beer on 28.06.11.
//  Copyright 2011 Christian Beer. All rights reserved.
//

#import "CBUIAttributedLabel.h"

#import "CBUITextAttachment.h"


NSString * const kCBCTHighlightedForegroundColorAttributeName = @"CBCTHighlightedForegroundColorAttributeName";
NSString * const kCBCTDefaultForegroundColorAttributeName = @"CBCTDefaultForegroundColorAttributeName";

NSString * const kCBUILinkAttribute = @"CBUILinkAttribute";


@implementation CBUIAttributedLabel
{
    NSMutableAttributedString   *_attributedText;
    
    NSArray                     *_links;
    NSMutableArray              *_attachmentViews;
}

@synthesize attributedText = _attributedText;

@synthesize verticalAlignment = _verticalAlignment;

@synthesize delegate = _delegate;


- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) return nil;
    
    self.verticalAlignment = VerticalAlignmentMiddle;
    _attachmentViews = nil;
    
    return self;
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (!self) return nil;
    
    self.verticalAlignment = VerticalAlignmentMiddle;
    _attachmentViews = nil;
    
    return self;
}

- (void)dealloc {
    
    
    if (_framesetter) CFRelease(_framesetter);
     _attachmentViews = nil;
    
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
        _framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)_attributedText);
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
            textRect.origin.y = bounds.size.height - textRect.size.height;
            break;
        case VerticalAlignmentBottom:
            textRect.origin.y = 0;
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
    
    CGContextSaveGState(context);
    
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    
    // Set the usual "flipped" Core Text draw matrix
	CGContextTranslateCTM(context, 0, ([self bounds]).size.height );
	CGContextScaleCTM(context, 1.0, -1.0);

    if (!_framesetter) return;
    
    CGPathRef path = CGPathCreateWithRect(actualRect, NULL);
    
    // Create the frame and draw it into the graphics context
    CTFrameRef frame = CTFramesetterCreateFrame(_framesetter, CFRangeMake(0, 0), path, NULL);
 
    NSArray *linesInFrame = (__bridge NSArray*)CTFrameGetLines(frame);
    
    for (UIView *view in _attachmentViews) {
        [view removeFromSuperview];
    }
     _attachmentViews = nil;
    _attachmentViews = [[NSMutableArray alloc] initWithCapacity:10];

    NSMutableArray *links = [[NSMutableArray alloc] init];
    
    [linesInFrame enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        CTLineRef line = (__bridge CTLineRef)obj;
        
        CGPoint lineOrigin;
        CTFrameGetLineOrigins(frame, CFRangeMake(idx, 1), &lineOrigin);
        
        [(__bridge NSArray*)CTLineGetGlyphRuns(line) enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            CTRunRef run = (__bridge CTRunRef)obj;
            
            NSDictionary *runAttributes = (__bridge NSDictionary*)CTRunGetAttributes(run);
            
            id attachment = [runAttributes objectForKey:@"NSAttachmentAttributeName"];
            if (attachment) {
                CGFloat ascent, descent, leading;
                CGFloat width = (CGFloat)CTRunGetTypographicBounds(run, CFRangeMake(0, 0), &ascent, &descent, &leading);
                CGFloat offsetInLine = CTLineGetOffsetForStringIndex(line, CTRunGetStringRange(run).location, NULL);
                CGRect frame = CGRectMake(offsetInLine + lineOrigin.x,
                                          self.bounds.size.height - lineOrigin.y - ascent,
                                          width, ascent + descent);
                
                switch (self.textAlignment) {
                    case UITextAlignmentCenter:
                        frame.origin.x -= width / 2;
                        break;
                    default:
                        break;
                }
                
                if ([attachment isKindOfClass:[CBUITextAttachment class]]) {
                    CBUITextAttachment *textAttachment = attachment;
                    if (textAttachment.drawCallback) {
                        textAttachment.drawCallback(context, frame, line, run);
                    } if (textAttachment.view) {
                        UIView *view = textAttachment.view;
                        view.frame = frame;
                        [_attachmentViews addObject:view];
                        [self addSubview:view];
                        
                        CGContextSetRGBStrokeColor(context, 1.0, 0.0, 0.0, 1.0);
                        CGContextStrokeRect(context, frame);
                    }
                }
            }
            
            id linkURL = [runAttributes objectForKey:kCBUILinkAttribute];
            if (linkURL) {
                CFRange cfRange = CTRunGetStringRange(run);
                NSRange runRange = NSMakeRange(cfRange.location, cfRange.length);
                CGRect runBounds;
                
                CGFloat ascent, descent, leading;
                runBounds.size.width = CTRunGetTypographicBounds(run, CFRangeMake(0, 0), &ascent, &descent, &leading);
                runBounds.size.height = ascent + descent;
                
                CGFloat xOffset = CTLineGetOffsetForStringIndex(line, runRange.location, NULL);
                runBounds.origin.x = lineOrigin.x + xOffset;
                runBounds.origin.y = actualRect.size.height - lineOrigin.y - ascent;
                
                runBounds = CGRectInset(runBounds, -10, -10);
                
                CBUIAttributedLabelLink *link = [[CBUIAttributedLabelLink alloc] init];
                link.range = runRange;
                link.frame = runBounds;
                link.link = linkURL;
                
                [links addObject:link];
            }
        }];
    }];

    
    _links = links;
    
    
    CTFrameDraw(frame, context);

    
    if (path) CFRelease(path);
    if (frame) CFRelease(frame);

    CGContextRestoreGState(context);

#ifdef DEBUG_LINKS
    [_links enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        CBUIAttributedLabelLink *link = obj;
        
        CGContextSetRGBStrokeColor(context, 1.0f, 0, 0, 1.0f);
        CGContextStrokeRect(context, link.frame);
    }];
#endif
}

#pragma mark - Acccessors

- (void) setAttributedText:(NSAttributedString*)inText {
    if (inText != _attributedText) {
        
        if ([inText isKindOfClass:[NSString class]]) {
            [self setText:(NSString*)inText];
        } else {
            _attributedText = [inText mutableCopy];
            
            [_attributedText enumerateAttribute:@"NSAttachmentAttributeName" inRange:NSMakeRange(0, _attributedText.length)
                                        options:0 usingBlock:^(id value, NSRange range, BOOL *stop) {
                                            if (!value) return;
                                            
                                            CBUITextAttachment *attachment = value;
                                            [_attributedText addAttribute:(id)kCTRunDelegateAttributeName
                                                                    value:(id)[attachment createCTRunDelegate] range:range];
                                        }];
            
            if (_framesetter) CFRelease(_framesetter);
            _framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)_attributedText);
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
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)attributedText);
    CGSize suggestedSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, 0), NULL, CGSizeMake(size.width, size.height), NULL);
    CFRelease(framesetter);
    return suggestedSize;
}

#pragma mark - Touch Handling

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    __block BOOL handled = NO;
    
    if (touches.count == 1) {
        UITouch *touch = [touches anyObject];
        
        if ([self.delegate respondsToSelector:@selector(attributedLabel:didTapOnLink:)]) {
            CGPoint location = [touch locationInView:self];
            
            [_links enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                CBUIAttributedLabelLink *link = obj;
                if (CGRectContainsPoint(link.frame, location)) {
                    handled = YES;
                    *stop = YES;
                }
            }];
        }
        
    }
    
    if (!handled) {
        [super touchesBegan:touches withEvent:event];
    }
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    __block BOOL handled = NO;
    
    if (touches.count == 1) {
        UITouch *touch = [touches anyObject];

        if ([self.delegate respondsToSelector:@selector(attributedLabel:didTapOnLink:)]) {
            CGPoint location = [touch locationInView:self];
              
            [_links enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                CBUIAttributedLabelLink *link = obj;
                if (CGRectContainsPoint(link.frame, location)) {
                    [self.delegate attributedLabel:self didTapOnLink:link];
                    handled = YES;
                    *stop = YES;
                }
            }];
        }
        
    }

    if (!handled) {
        [super touchesEnded:touches withEvent:event];
    }
}

@end


@implementation CBUIAttributedLabelLink

@synthesize range = _range;
@synthesize frame = _frame;

@synthesize link = _link;

@end
