//
//  UIGestureRecognizer+Blocks.h
//  CBUIKit
//
//  Created by Christian Beer on 11.07.11.
//  Copyright 2011 Christian Beer. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^CBUIKitGestureRecognizerHandler)(UIGestureRecognizer *recognizer);

@interface UIGestureRecognizer (CBUIKit_Blocks)

- (instancetype)initWithGestureHandler:(CBUIKitGestureRecognizerHandler)handler;

@end
