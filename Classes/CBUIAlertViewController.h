//
//  CBUIAlertViewController.h
//  CBUIKit
//
//  Created by Christian Beer on 03.08.11.
//  Copyright 2011 Christian Beer. All rights reserved.
//
#import <UIKit/UIKit.h>

@class CBUIAlertViewControllerButton;

typedef void(^CBUIAlertViewHandler)(UIAlertView *alertView, NSUInteger buttonIndex);

@interface CBUIAlertViewController : NSObject <UIAlertViewDelegate> {
    
    UIAlertView                         *alertView;
    
    NSString                            *title;
    NSString                            *message;
    
    CBUIAlertViewControllerButton       *cancelButton;
    CBUIAlertViewControllerButton       *destructiveButton;
    NSMutableArray                      *buttons;
    
}

@property (nonatomic, assign) UIAlertViewStyle alertViewStyle;

+ (id) alertWithTitle:(NSString*)title message:(NSString*)message;
+ (id) alertWithMessage:(NSString*)message;

- (instancetype) initWithTitle:(NSString*)inTitle message:(NSString*)inMessage NS_DESIGNATED_INITIALIZER;
- (instancetype) initWithTitle:(NSString*)inTitle message:(NSString*)inMessage buttonsWithHandlerAndTitle:(id)firstHandler, ...;

- (void) setCancelButtonTitle:(NSString*)title handler:(CBUIAlertViewHandler)handler;
- (void) addButtonWithTitle:(NSString*)title handler:(CBUIAlertViewHandler)handler;

- (void) show;

@end