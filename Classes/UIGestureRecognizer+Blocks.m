//
//  UIGestureRecognizer+Blocks.m
//  CBUIKit
//
//  Created by Christian Beer on 11.07.11.
//  Copyright 2011 Christian Beer. All rights reserved.
//

#import "UIGestureRecognizer+Blocks.h"
#import "objc/runtime.h"

static const char *BlockHandlerKey = "CBUIKitBlockHandlerKey";

@implementation UIGestureRecognizer (CBUIKit_Blocks)

- (id)initWithGestureHandler:(CBUIKitGestureRecognizerHandler)handler
{
    self = [self initWithTarget:self action:@selector(__gestureRecognizerStateChanged:)];
    if (!self) return nil;
    
    objc_setAssociatedObject(self, BlockHandlerKey, handler, OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    return self;
}

- (void) __gestureRecognizerStateChanged:(UIGestureRecognizer*)recognizer
{
    CBUIKitGestureRecognizerHandler handler = objc_getAssociatedObject(self, BlockHandlerKey);
    handler(recognizer);
}

@end
