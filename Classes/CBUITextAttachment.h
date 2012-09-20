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

@property (nonatomic, copy) CBUITextAttachmentGetFloatValueCallback getAscentCallback;
@property (nonatomic, copy) CBUITextAttachmentGetFloatValueCallback getDescentCallback;
@property (nonatomic, copy) CBUITextAttachmentGetFloatValueCallback getWidthCallback;
@property (nonatomic, copy) CBUITextAttachmentDrawCallback          drawCallback;

- (id) initWithGetAscent:(CBUITextAttachmentGetFloatValueCallback)getAscentCallback
              getDescent:(CBUITextAttachmentGetFloatValueCallback)getDescentCallback
                getWidth:(CBUITextAttachmentGetFloatValueCallback)getWidthCallback
                    draw:(CBUITextAttachmentDrawCallback)draw;
- (id) initWithAscent:(CGFloat)ascent
              descent:(CGFloat)descent
                width:(CGFloat)width
                 draw:(CBUITextAttachmentDrawCallback)draw;

@end
