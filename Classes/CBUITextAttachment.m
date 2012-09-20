//
//  CBUITextAttachment.m
//  CBCoreTextKit
//
//  Created by Christian Beer on 05.09.12.
//  Copyright (c) 2012 Christian Beer. All rights reserved.
//

#import "CBUITextAttachment.h"


@implementation CBUITextAttachment

- (id) initWithGetAscent:(CBUITextAttachmentGetFloatValueCallback)getAscentCallback
              getDescent:(CBUITextAttachmentGetFloatValueCallback)getDescentCallback
                getWidth:(CBUITextAttachmentGetFloatValueCallback)getWidthCallback
                    draw:(CBUITextAttachmentDrawCallback)draw;
{
    self = [super init];
    if (!self) return nil;
    
    self.getAscentCallback = getAscentCallback;
    self.getDescentCallback = getDescentCallback;
    self.getWidthCallback = getWidthCallback;
    self.drawCallback = draw;
    
    return self;
}

- (id) initWithAscent:(CGFloat)ascent
              descent:(CGFloat)descent
                width:(CGFloat)width
                 draw:(CBUITextAttachmentDrawCallback)draw;
{
    return [self initWithGetAscent:^CGFloat{
                            return ascent;
                        }
                        getDescent:^CGFloat{
                            return descent;
                        }
                          getWidth:^CGFloat{
                              return width;
                          }
                              draw:draw];
}

@end


///// Callbacks /////

void CBUITextAttachmentRunDelegateDealloc(void *context)
{
}

CGFloat CBUITextAttachmentRunDelegateGetAscent(void *context)
{
    if ([(__bridge id)context isKindOfClass:[CBUITextAttachment class]]) {
        CBUITextAttachment *att = (__bridge CBUITextAttachment *)(context);
        
        if (att.getAscentCallback) {
            return att.getAscentCallback();
        }
        
    }
    return 0;
}
CGFloat CBUITextAttachmentRunDelegateGetDescent(void *context)
{
    if ([(__bridge id)context isKindOfClass:[CBUITextAttachment class]]) {
        CBUITextAttachment *att = (__bridge CBUITextAttachment *)(context);
        
        if (att.getDescentCallback) {
            return att.getDescentCallback();
        }

    }
    return 0;
}
CGFloat CBUITextAttachmentRunDelegateGetWidth(void *context)
{
    if ([(__bridge id)context isKindOfClass:[CBUITextAttachment class]]) {
        CBUITextAttachment *att = (__bridge CBUITextAttachment *)(context);
        
        if (att.getWidthCallback) {
            return att.getWidthCallback();
        }
    
    }
    return 0;
}

CTRunDelegateCallbacks CBUITextAttachmentRunDelegateCreate(CBUITextAttachment *attachment)
{
    CTRunDelegateCallbacks callbacks;
	callbacks.version = kCTRunDelegateCurrentVersion;
    callbacks.dealloc = CBUITextAttachmentRunDelegateDealloc;
    callbacks.getAscent = CBUITextAttachmentRunDelegateGetAscent;
    callbacks.getDescent = CBUITextAttachmentRunDelegateGetDescent;
    callbacks.getWidth = CBUITextAttachmentRunDelegateGetWidth;
    
    return callbacks;
}