//
//  UIView+CBUIKit.h
//  CBUIKit
//
//  Created by Christian Beer on 17.11.11.
//  Copyright (c) 2011 Christian Beer. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CBUIGlobal.h"

@interface UIView (CBUIKit)

- (UIView*) cbFirstSuperviewWithClass:(Class)class;

- (void) cbModifyFrame:(CBCGRectModifyBlock) modifyBlock;
- (void) cbModifyBounds:(CBCGRectModifyBlock) modifyBlock;

@end
