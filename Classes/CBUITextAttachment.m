//
//  CBUITextAttachment.m
//  CBCoreTextKit
//
//  Created by Christian Beer on 05.09.12.
//  Copyright (c) 2012 Christian Beer. All rights reserved.
//

#import "CBUITextAttachment.h"

void CBUITextAttachmentRunDelegateDealloc(void *context);
CGFloat CBUITextAttachmentRunDelegateGetAscent(void *context);
CGFloat CBUITextAttachmentRunDelegateGetDescent(void *context);
CGFloat CBUITextAttachmentRunDelegateGetWidth(void *context);


@interface CBUITextAttachment ()

@property (nonatomic, readwrite, copy) CBUITextAttachmentGetFloatValueCallback getAscentCallback;
@property (nonatomic, readwrite, copy) CBUITextAttachmentGetFloatValueCallback getDescentCallback;
@property (nonatomic, readwrite, copy) CBUITextAttachmentGetFloatValueCallback getWidthCallback;

@property (nonatomic, readwrite, strong) UIView                                *view;
@property (nonatomic, readwrite, copy)   CBUITextAttachmentDrawCallback        drawCallback;

@end

@implementation CBUITextAttachment

- (instancetype) initWithView:(UIView*)view;
{
    self = [super init];
    if (!self) return nil;
    
    self.getAscentCallback = ^{
        return view.bounds.size.height;
    };
    self.getDescentCallback = ^{
        return (CGFloat)0.0;
    };
    self.getWidthCallback = ^{
        return view.bounds.size.width;
    };
    self.view = view;
    
    return self;
}

- (instancetype) initWithGetAscent:(CBUITextAttachmentGetFloatValueCallback)getAscentCallback
              getDescent:(CBUITextAttachmentGetFloatValueCallback)getDescentCallback
                getWidth:(CBUITextAttachmentGetFloatValueCallback)getWidthCallback
            drawCallback:(CBUITextAttachmentDrawCallback)draw;
{
    self = [super init];
    if (!self) return nil;
    
    self.getAscentCallback = getAscentCallback;
    self.getDescentCallback = getDescentCallback;
    self.getWidthCallback = getWidthCallback;
    self.drawCallback = draw;
    
    return self;
}
- (instancetype) initWithAscent:(CGFloat)ascent
              descent:(CGFloat)descent
                width:(CGFloat)width
         drawCallback:(CBUITextAttachmentDrawCallback)draw;
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
                      drawCallback:draw];
}

#pragma mark -

- (CTRunDelegateRef) createCTRunDelegate
{
    CTRunDelegateCallbacks callbacks;
	callbacks.version = kCTRunDelegateCurrentVersion;
    callbacks.dealloc = CBUITextAttachmentRunDelegateDealloc;
    callbacks.getAscent = CBUITextAttachmentRunDelegateGetAscent;
    callbacks.getDescent = CBUITextAttachmentRunDelegateGetDescent;
    callbacks.getWidth = CBUITextAttachmentRunDelegateGetWidth;
	return CTRunDelegateCreate(&callbacks, (__bridge void *)self);
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
