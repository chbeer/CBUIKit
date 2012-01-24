//
//  CBUIActionSheetController.m
//  CBUIKit
//
//  Created by Christian Beer on 06.07.11.
//  Copyright 2011 Christian Beer. All rights reserved.
//

#import "CBUIActionSheetController.h"

@interface CBUIActionSheetControllerButton : NSObject
@property (nonatomic, copy) CBUIActionSheetHandler handler;
@property (nonatomic, copy) NSString *title;
+ (id) buttonWithTitle:(NSString*)title handler:(CBUIActionSheetHandler)handler;
@end


@implementation CBUIActionSheetController

@synthesize actionSheetStyle;

- (id) initWithTitle:(NSString*)inTitle
{
    self = [super init];
    if (!self) return nil;

    title   = [inTitle copy];
    
    buttons = [[NSMutableArray alloc] init];
    
    return self;
}

- (id) initWithTitle:(NSString*)inTitle buttonsWithHandlerAndTitle:(CBUIActionSheetHandler)firstHandler, ...
{
    self = [self initWithTitle:inTitle];
    if (!self) return nil;

    if (firstHandler) {
        va_list args;
        va_start(args, firstHandler);
        id obj;
        CBUIActionSheetHandler handler = firstHandler;
        while ((obj = va_arg(args, NSObject *))) {
            if (handler) {
                [buttons addObject:[CBUIActionSheetControllerButton buttonWithTitle:obj handler:handler]];
                handler = nil;
            } else {
                handler = obj;
            }
        }
        va_end(args);
    }
    
    return self;
}

+ (id) actionSheetControllerWithTitle:(NSString*)title buttonsWithHandlerAndTitle:(CBUIActionSheetHandler)firstHandler, ...
{
    CBUIActionSheetController *ctrl = [[self alloc] initWithTitle:title];
    
    if (firstHandler) {
        va_list args;
        va_start(args, firstHandler);
        id obj;
        CBUIActionSheetHandler handler = firstHandler;
        while ((obj = va_arg(args, NSObject *))) {
            if (handler) {
                [ctrl addButtonWithTitle:obj handler:handler];
                handler = nil;
            } else {
                handler = obj;
            }
        }
        va_end(args);
    }
    
    return [ctrl autorelease];
}
+ (id) actionSheetControllerWithTitle:(NSString*)title
{
    CBUIActionSheetController *ctrl = [[self alloc] initWithTitle:title];
    return [ctrl autorelease];
}

- (void)dealloc {
    [actionSheet release], actionSheet = nil;
    
    [title release], title = nil;
    [cancelButton release], cancelButton = nil;
    [destructiveButton release], destructiveButton = nil;
    
    [buttons release], buttons = nil;
    
    [super dealloc];
}

#pragma mark add buttons

- (void) setCancelButtonTitle:(NSString*)inTitle handler:(CBUIActionSheetHandler)handler
{
    [cancelButton release];
    cancelButton = [[CBUIActionSheetControllerButton buttonWithTitle:inTitle handler:handler] retain];
}
- (void) setDestructiveButtonTitle:(NSString*)inTitle handler:(CBUIActionSheetHandler)handler
{
    [destructiveButton release];
    destructiveButton = [[CBUIActionSheetControllerButton buttonWithTitle:inTitle handler:handler] retain];
}
- (void) addButtonWithTitle:(NSString*)inTitle handler:(CBUIActionSheetHandler)handler
{
    [buttons addObject:[CBUIActionSheetControllerButton buttonWithTitle:inTitle handler:handler]];
}

- (id) applyCancelButtonTitle:(NSString*)inTitle handler:(CBUIActionSheetHandler)handler;
{
    [self setCancelButtonTitle:inTitle handler:handler];
    return self;
}
- (id) applyDestructiveButtonTitle:(NSString*)inTitle handler:(CBUIActionSheetHandler)handler;
{
    [self setDestructiveButtonTitle:inTitle handler:handler];
    return self;
}
- (id) applyButtonWithTitle:(NSString*)inTitle handler:(CBUIActionSheetHandler)handler;
{
    [self addButtonWithTitle:inTitle handler:handler];
    return self;
}

#pragma mark Show

- (UIActionSheet*) actionSheet
{
    if (!actionSheet) {
        actionSheet = [[UIActionSheet alloc] initWithTitle:title 
                                                  delegate:self
                                         cancelButtonTitle:nil
                                    destructiveButtonTitle:destructiveButton.title 
                                         otherButtonTitles:nil];
        for (CBUIActionSheetControllerButton *button in buttons) {
            [actionSheet addButtonWithTitle:button.title];
        }
        
        if (cancelButton.title) {
            NSInteger cancelIndex = [actionSheet addButtonWithTitle:cancelButton.title];
            actionSheet.cancelButtonIndex = cancelIndex;
        }
//        if (destructiveButton && cancelButton) actionSheet.cancelButtonIndex++;
    } 
    return actionSheet;
}

- (void)showFromToolbar:(UIToolbar *)view;
{
    [[self actionSheet] showFromToolbar:view];
    [self retain];
}
- (void)showFromTabBar:(UITabBar *)view;
{
    [[self actionSheet] showFromTabBar:view];
    [self retain];
}
- (void)showFromBarButtonItem:(UIBarButtonItem *)item animated:(BOOL)animated;
{
    [[self actionSheet] showFromBarButtonItem:item animated:animated];
    [self retain];
}
- (void)showFromRect:(CGRect)rect inView:(UIView *)view animated:(BOOL)animated;
{
    [[self actionSheet] showFromRect:rect inView:view animated:animated];
    [self retain];
}
- (void)showInView:(UIView *)view;
{
    [[self actionSheet] showInView:view];
    [self retain];
}

#pragma mark UIActionSheetDelegate
     
- (void)actionSheet:(UIActionSheet *)inActionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == inActionSheet.cancelButtonIndex) {
        if (cancelButton.handler) {
            cancelButton.handler();
        }
    } else if (buttonIndex == inActionSheet.destructiveButtonIndex) {
        if (destructiveButton.handler) {
            destructiveButton.handler();
        }
    } else {
        NSInteger index = buttonIndex;
        if (inActionSheet.destructiveButtonIndex != -1) {
            index--;
        }
        CBUIActionSheetControllerButton *button = [buttons objectAtIndex:index];
        if (button.handler) {
            button.handler();
        }
    }
}

- (void)actionSheet:(UIActionSheet *)inActionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    [self autorelease];
}

@end


@implementation CBUIActionSheetControllerButton
@synthesize title = _title, handler = _handler;
+ (id) buttonWithTitle:(NSString*)title handler:(CBUIActionSheetHandler)handler
{
    CBUIActionSheetControllerButton *button = [[CBUIActionSheetControllerButton alloc] init];
    button.title = title;
    button.handler = handler;
    return [button autorelease];
}
- (void)dealloc {
    [_title release], _title = nil;
    [_handler release], _handler = nil;
    [super dealloc];
}
@end