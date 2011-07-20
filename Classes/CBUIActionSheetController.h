//
//  CBUIActionSheetController.h
//  CBUIKit
//
//  Created by Christian Beer on 06.07.11.
//  Copyright 2011 Christian Beer. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CBUIActionSheetControllerButton;

@interface CBUIActionSheetController : NSObject <UIActionSheetDelegate> {
    
    UIActionSheet                       *actionSheet;
    
    NSString                            *title;
    
    id                                  target;
    
    CBUIActionSheetControllerButton     *cancelButton;
    CBUIActionSheetControllerButton     *destructiveButton;
    NSMutableArray                      *buttons;
    
}

@property (nonatomic, assign) UIActionSheetStyle actionSheetStyle;

- (id) initWithTitle:(NSString*)inTitle target:(id)inTarget;

- (void) setCancelButtonTitle:(NSString*)title action:(SEL)action;
- (void) setDestructiveButtonTitle:(NSString*)title action:(SEL)action;
- (void) addButtonWithTitle:(NSString*)title action:(SEL)action;

- (void)showFromToolbar:(UIToolbar *)view;
- (void)showFromTabBar:(UITabBar *)view;
- (void)showFromBarButtonItem:(UIBarButtonItem *)item animated:(BOOL)animated;
- (void)showFromRect:(CGRect)rect inView:(UIView *)view animated:(BOOL)animated;
- (void)showInView:(UIView *)view;

@end
