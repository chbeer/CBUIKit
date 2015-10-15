//
//  CBUIAlertViewController.h
//  CBUIKit
//
//  Created by Christian Beer on 03.08.11.
//  Copyright 2011 Christian Beer. All rights reserved.
//
#import <UIKit/UIKit.h>

@class CBUIAlertViewControllerButton;

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
typedef void(^CBUIAlertViewHandler)(UIAlertView *alertView, NSUInteger buttonIndex);
#pragma clang diagnostic pop

NS_CLASS_DEPRECATED_IOS(2_0, 8_3, "CBUIAlertViewController is deprecated. Use UIAlertController instead")
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

- (instancetype) initWithTitle:(NSString*)inTitle message:(NSString*)inMessage;
- (instancetype) initWithTitle:(NSString*)inTitle message:(NSString*)inMessage buttonsWithHandlerAndTitle:(id)firstHandler, ...;

- (void) setCancelButtonTitle:(NSString*)title handler:(CBUIAlertViewHandler)handler;
- (void) addButtonWithTitle:(NSString*)title handler:(CBUIAlertViewHandler)handler;

- (void) show;

@end