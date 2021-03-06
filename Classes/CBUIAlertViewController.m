//
//  CBUIAlertViewController.m
//  CBUIKit
//
//  Created by Christian Beer on 06.07.11.
//  Copyright 2011 Christian Beer. All rights reserved.
//

#import "CBUIAlertViewController.h"

#import <objc/runtime.h>


static const char kCBUIAlertViewController;

@interface CBUIAlertViewControllerButton : NSObject
@property (nonatomic, copy) CBUIAlertViewHandler handler;
@property (nonatomic, copy) NSString *title;
+ (id) buttonWithTitle:(NSString*)title handler:(CBUIAlertViewHandler)handler;
@end


@implementation CBUIAlertViewController

@synthesize alertViewStyle;

- (instancetype) initWithTitle:(NSString*)inTitle message:(NSString*)inMessage
{
    self = [super init];
    if (!self) return nil;
    
    title   = [inTitle copy];
    message = [inMessage copy];
    
    buttons = [[NSMutableArray alloc] init];
    
    return self;
}
- (instancetype) initWithTitle:(NSString*)inTitle message:(NSString*)inMessage buttonsWithHandlerAndTitle:(id)firstHandler, ...
{
    self = [self initWithTitle:inTitle message:inMessage];
    if (!self) return nil;

    if (firstHandler) {
        va_list args;
        va_start(args, firstHandler);
        id obj;
        CBUIAlertViewHandler handler = firstHandler;
        while ((obj = va_arg(args, NSObject *))) {
            if (handler) {
                [buttons addObject:[CBUIAlertViewControllerButton buttonWithTitle:obj handler:handler]];
                handler = nil;
            } else {
                handler = obj;
            }
        }
        va_end(args);
    }
    
    return self;
}

- (void)dealloc {
    alertView = nil;
    
    title = nil;
    cancelButton = nil;
    destructiveButton = nil;
    
    buttons = nil;
    
}

#pragma mark Convenience Methods

+ (id) alertWithTitle:(NSString*)title message:(NSString*)message
{
    id instance = [[self alloc] initWithTitle:title message:message];
    [instance addButtonWithTitle:NSLocalizedString(@"OK", @"") handler:nil];
    [instance show];
    return instance;
}
+ (id) alertWithMessage:(NSString*)message
{
    return [self alertWithTitle:nil message:message];
}

#pragma mark add buttons

- (void) setCancelButtonTitle:(NSString*)inTitle handler:(CBUIAlertViewHandler)handler
{
    cancelButton = [CBUIAlertViewControllerButton buttonWithTitle:inTitle handler:handler];
}
- (void) addButtonWithTitle:(NSString*)inTitle handler:(CBUIAlertViewHandler)handler
{
    [buttons addObject:[CBUIAlertViewControllerButton buttonWithTitle:inTitle handler:handler]];
}

#pragma mark Show

- (UIAlertView*) alertView
{
    if (!alertView) {
        alertView = [[UIAlertView alloc] initWithTitle:title 
                                               message:message 
                                              delegate:self
                                     cancelButtonTitle:nil
                                     otherButtonTitles:nil];
        for (CBUIAlertViewControllerButton *button in buttons) {
            [alertView addButtonWithTitle:button.title];
        }
        
        if (cancelButton.title) {
            [alertView addButtonWithTitle:cancelButton.title];
            alertView.cancelButtonIndex = buttons.count;
        }
    }
    
    objc_setAssociatedObject(alertView, &kCBUIAlertViewController, self, OBJC_ASSOCIATION_RETAIN);
    
    return alertView;
}

- (void)show
{
    [[self alertView] show];
}


#pragma mark UIAlertViewDelegate

- (void)alertView:(UIAlertView *)inAlertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == inAlertView.cancelButtonIndex) {
        if (cancelButton.handler) {
            cancelButton.handler(inAlertView, buttonIndex);
        }
    } else {
        CBUIAlertViewControllerButton *button = buttons[buttonIndex];
        if (button.handler) {
            button.handler(inAlertView, buttonIndex);
        }
    }

}

- (void)alertView:(UIAlertView *)inAlertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    objc_setAssociatedObject(inAlertView, &
                             kCBUIAlertViewController, nil, OBJC_ASSOCIATION_RETAIN);
}

@end


@implementation CBUIAlertViewControllerButton
@synthesize title = _title, handler = _handler;
+ (id) buttonWithTitle:(NSString*)title handler:(CBUIAlertViewHandler)handler
{
    CBUIAlertViewControllerButton *button = [[CBUIAlertViewControllerButton alloc] init];
    button.title = title;
    button.handler = handler;
    return button;
}
- (void)dealloc {
    _title = nil;
    _handler = nil;
}
@end