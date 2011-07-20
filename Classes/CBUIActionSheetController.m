//
//  CBUIActionSheetController.m
//  CBUIKit
//
//  Created by Christian Beer on 06.07.11.
//  Copyright 2011 Christian Beer. All rights reserved.
//

#import "CBUIActionSheetController.h"

@interface CBUIActionSheetControllerButton : NSObject
@property (nonatomic, assign) SEL action;
@property (nonatomic, copy) NSString *title;
+ (id) buttonWithTitle:(NSString*)title action:(SEL)action;
@end


@implementation CBUIActionSheetController

@synthesize actionSheetStyle;

- (id) initWithTitle:(NSString*)inTitle target:(id)inTarget 
{
    self = [super init];
    if (!self) return nil;

    title   = [inTitle copy];
    target  = inTarget;
    
    buttons = [[NSMutableArray alloc] init];
    
    return self;
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

- (void) setCancelButtonTitle:(NSString*)inTitle action:(SEL)action
{
    [cancelButton release];
    cancelButton = [[CBUIActionSheetControllerButton buttonWithTitle:inTitle action:action] retain];
}
- (void) setDestructiveButtonTitle:(NSString*)inTitle action:(SEL)action
{
    [destructiveButton release];
    destructiveButton = [[CBUIActionSheetControllerButton buttonWithTitle:inTitle action:action] retain];
}
- (void) addButtonWithTitle:(NSString*)inTitle action:(SEL)action
{
    [buttons addObject:[CBUIActionSheetControllerButton buttonWithTitle:inTitle action:action]];
}

#pragma mark Show

- (UIActionSheet*) actionSheet
{
    if (!actionSheet) {
        actionSheet = [[UIActionSheet alloc] initWithTitle:title 
                                                  delegate:self
                                         cancelButtonTitle:cancelButton.title 
                                    destructiveButtonTitle:destructiveButton.title 
                                         otherButtonTitles:nil];
        for (CBUIActionSheetControllerButton *button in buttons) {
            [actionSheet addButtonWithTitle:button.title];
        }
    } 
    return actionSheet;
}

- (void)showFromToolbar:(UIToolbar *)view;
{
    [[self actionSheet] showFromToolbar:view];
}
- (void)showFromTabBar:(UITabBar *)view;
{
    [[self actionSheet] showFromTabBar:view];
}
- (void)showFromBarButtonItem:(UIBarButtonItem *)item animated:(BOOL)animated;
{
    [[self actionSheet] showFromBarButtonItem:item animated:animated];
}
- (void)showFromRect:(CGRect)rect inView:(UIView *)view animated:(BOOL)animated;
{
    [[self actionSheet] showFromRect:rect inView:view animated:animated];
}
- (void)showInView:(UIView *)view;
{
    [[self actionSheet] showInView:view];
}

#pragma mark UIActionSheetDelegate
     
- (void)actionSheet:(UIActionSheet *)inActionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == inActionSheet.cancelButtonIndex) {
        if (cancelButton) {
            [target performSelector:cancelButton.action withObject:self];
        }
    } else if (buttonIndex == inActionSheet.destructiveButtonIndex) {
        if (destructiveButton) {
            [target performSelector:destructiveButton.action withObject:self];
        }
    } else {
        CBUIActionSheetControllerButton *button = [buttons objectAtIndex:buttonIndex];
        [target performSelector:button.action withObject:self];
    }
}

- (void)actionSheet:(UIActionSheet *)inActionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    [self autorelease];
}

@end


@implementation CBUIActionSheetControllerButton
@synthesize action, title;
+ (id) buttonWithTitle:(NSString*)title action:(SEL)action
{
    CBUIActionSheetControllerButton *button = [[CBUIActionSheetControllerButton alloc] init];
    button.title = title;
    button.action = action;
    return [button autorelease];
}
- (void)dealloc {
    [title release], title = nil;
    [super dealloc];
}
@end