//
//  CBUIActivityView.h
//  CBUIKit
//
//  Created by Christian Beer on 05.07.11.
//  Copyright 2011 Christian Beer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CBUIActivityView : UIView

+ (CBUIActivityView*) sharedInstance;

- (CBUIActivityView*) showSpinnerWithMessage:(NSString*)message;
- (CBUIActivityView*) showInfoIcon:(UIImage*)icon withMessage:(NSString *)message;
- (CBUIActivityView*) showCenterText:(NSString*)text withMessage:(NSString *)message;

- (void) hide:(BOOL)animated;
- (void) hide;
- (void) hideAfterDelay:(NSTimeInterval)delay;

- (void) setMessage:(NSString *)message;

- (CBUIActivityView*) applyBackgroundColor:(UIColor*)color;

@end
