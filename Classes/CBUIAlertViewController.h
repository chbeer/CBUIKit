//
//  CBUIAlertViewController.h
//  CBUIKit
//
//  Created by Christian Beer on 03.08.11.
//  Copyright 2011 Christian Beer. All rights reserved.
//
#import <UIKit/UIKit.h>

@class CBUIAlertViewControllerButton;

@interface CBUIAlertViewController : NSObject <UIAlertViewDelegate> {
    
    UIAlertView                         *alertView;
    
    NSString                            *title;
    NSString                            *message;
    
    id                                  target;
    
    CBUIAlertViewControllerButton       *cancelButton;
    CBUIAlertViewControllerButton       *destructiveButton;
    NSMutableArray                      *buttons;
    
}

@property (nonatomic, assign) UIAlertViewStyle alertViewStyle;

+ (id) alertWithTitle:(NSString*)title message:(NSString*)message;
+ (id) alertWithMessage:(NSString*)message;

- (id) initWithTitle:(NSString*)inTitle message:(NSString*)inMessage target:(id)inTarget;

- (void) setCancelButtonTitle:(NSString*)title action:(SEL)action;
- (void) addButtonWithTitle:(NSString*)title action:(SEL)action;

- (void) show;

@end