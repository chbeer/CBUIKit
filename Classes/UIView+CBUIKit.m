//
//  UIView+CBUIKit.m
//  CBUIKit
//
//  Created by Christian Beer on 17.11.11.
//  Copyright (c) 2011 Christian Beer. All rights reserved.
//

#import "UIView+CBUIKit.h"

@implementation UIView (CBUIKit)

- (UIView*) cbFirstSuperviewWithClass:(Class)class
{
    if (self.superview == nil) return nil; 
    else if ([self.superview isKindOfClass:class]) {
        return self.superview;
    } else {
        return [self.superview cbFirstSuperviewWithClass:class];
    }
}

@end
