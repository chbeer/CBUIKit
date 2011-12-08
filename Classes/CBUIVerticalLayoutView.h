//
//  CBUIVerticalLayoutView.h
//  CBUIKit
//
//  Created by Christian Beer on 09.11.11.
//  Copyright (c) 2011 Christian Beer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CBUIVerticalLayoutView : UIView

@property (nonatomic, assign) UIEdgeInsets insets;
@property (nonatomic, assign) CGFloat spacing;

- (void) setInsetsString:(NSString*)insetsString;

@end
