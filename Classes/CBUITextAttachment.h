//
//  CBUITextAttachment.h
//  CBCoreTextKit
//
//  Created by Christian Beer on 05.09.12.
//  Copyright (c) 2012 Christian Beer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>


typedef CGFloat(^CBUITextAttachmentGetFloatValueCallback)();
typedef CGFloat(^CBUITextAttachmentDrawCallback)(CGContextRef ctx, CGRect frame, CTLineRef line, CTRunRef run);

@interface CBUITextAttachment : NSObject

@property (nonatomic, readonly, copy) CBUITextAttachmentGetFloatValueCallback getAscentCallback;
@property (nonatomic, readonly, copy) CBUITextAttachmentGetFloatValueCallback getDescentCallback;
@property (nonatomic, readonly, copy) CBUITextAttachmentGetFloatValueCallback getWidthCallback;

@property (nonatomic, readonly, strong) UIView                                *view;
@property (nonatomic, readonly, copy)   CBUITextAttachmentDrawCallback        drawCallback;

- (instancetype) initWithView:(UIView*)view NS_DESIGNATED_INITIALIZER;

- (instancetype) initWithGetAscent:(CBUITextAttachmentGetFloatValueCallback)getAscentCallback
              getDescent:(CBUITextAttachmentGetFloatValueCallback)getDescentCallback
                getWidth:(CBUITextAttachmentGetFloatValueCallback)getWidthCallback
            drawCallback:(CBUITextAttachmentDrawCallback)draw NS_DESIGNATED_INITIALIZER;
- (instancetype) initWithAscent:(CGFloat)ascent
              descent:(CGFloat)descent
                width:(CGFloat)width
         drawCallback:(CBUITextAttachmentDrawCallback)draw;

@property (NS_NONATOMIC_IOSONLY, readonly) CTRunDelegateRef createCTRunDelegate;

@end
