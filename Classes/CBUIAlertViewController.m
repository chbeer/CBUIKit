//
//  CBUIAlertViewController.m
//  CBUIKit
//
//  Created by Christian Beer on 06.07.11.
//  Copyright 2011 Christian Beer. All rights reserved.
//

#import "CBUIAlertViewController.h"

@interface CBUIAlertViewControllerButton : NSObject
@property (nonatomic, assign) SEL action;
@property (nonatomic, copy) NSString *title;
+ (id) buttonWithTitle:(NSString*)title action:(SEL)action;
@end


@implementation CBUIAlertViewController

@synthesize alertViewStyle;

- (id) initWithTitle:(NSString*)inTitle message:(NSString*)inMessage target:(id)inTarget 
{
    self = [super init];
    if (!self) return nil;
    
    title   = [inTitle copy];
    message = [inMessage copy];
    
    target  = inTarget;
    
    buttons = [[NSMutableArray alloc] init];
    
    return self;
}

- (void)dealloc {
    [alertView release], alertView = nil;
    
    [title release], title = nil;
    [cancelButton release], cancelButton = nil;
    [destructiveButton release], destructiveButton = nil;
    
    [buttons release], buttons = nil;
    
    [super dealloc];
}

#pragma mark Convenience Methods

+ (id) alertWithTitle:(NSString*)title message:(NSString*)message
{
    id instance = [[self alloc] initWithTitle:title message:message 
                                       target:nil];
    [instance show];
    [instance autorelease];
    return instance;
}
+ (id) alertWithMessage:(NSString*)message
{
    return [self alertWithTitle:nil message:message];
}

#pragma mark add buttons

- (void) setCancelButtonTitle:(NSString*)inTitle action:(SEL)action
{
    [cancelButton release];
    cancelButton = [[CBUIAlertViewControllerButton buttonWithTitle:inTitle action:action] retain];
}
- (void) addButtonWithTitle:(NSString*)inTitle action:(SEL)action
{
    [buttons addObject:[CBUIAlertViewControllerButton buttonWithTitle:inTitle action:action]];
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
        if (cancelButton.action) {
            [target performSelector:cancelButton.action withObject:self];
        }
    } else {
        CBUIAlertViewControllerButton *button = [buttons objectAtIndex:buttonIndex];
        if (button.action) {
            [target performSelector:button.action withObject:self];
        }
    }

    [self autorelease];
}

@end


@implementation CBUIAlertViewControllerButton
@synthesize action, title;
+ (id) buttonWithTitle:(NSString*)title action:(SEL)action
{
    CBUIAlertViewControllerButton *button = [[CBUIAlertViewControllerButton alloc] init];
    button.title = title;
    button.action = action;
    return [button autorelease];
}
- (void)dealloc {
    [title release], title = nil;
    [super dealloc];
}
@end