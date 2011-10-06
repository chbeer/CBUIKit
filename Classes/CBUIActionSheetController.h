//
//  CBUIActionSheetController.h
//  CBUIKit
//
//  Created by Christian Beer on 06.07.11.
//  Copyright 2011 Christian Beer. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CBUIActionSheetControllerButton;

typedef void(^CBUIActionSheetHandler)();

@interface CBUIActionSheetController : NSObject <UIActionSheetDelegate> {
    
    UIActionSheet                       *actionSheet;
    
    NSString                            *title;
    
    id                                  target;
    
    CBUIActionSheetControllerButton     *cancelButton;
    CBUIActionSheetControllerButton     *destructiveButton;
    
    NSMutableArray                      *buttons;
    
}

@property (nonatomic, assign) UIActionSheetStyle actionSheetStyle;

+ (id) actionSheetControllerWithTitle:(NSString*)title buttonsWithHandlerAndTitle:(id)firstHandler, ...;
+ (id) actionSheetControllerWithTitle:(NSString*)title;

- (id) applyCancelButtonTitle:(NSString*)title handler:(CBUIActionSheetHandler)handler;
- (id) applyDestructiveButtonTitle:(NSString*)title handler:(CBUIActionSheetHandler)handler;
- (id) applyButtonWithTitle:(NSString*)title handler:(CBUIActionSheetHandler)handler;

- (id) initWithTitle:(NSString*)inTitle;
- (id) initWithTitle:(NSString*)inTitle buttonsWithHandlerAndTitle:(id)firstHandler, ...;

- (void) setCancelButtonTitle:(NSString*)title handler:(CBUIActionSheetHandler)handler;
- (void) setDestructiveButtonTitle:(NSString*)title handler:(CBUIActionSheetHandler)handler;
- (void) addButtonWithTitle:(NSString*)title handler:(CBUIActionSheetHandler)handler;

- (void)showFromToolbar:(UIToolbar *)view;
- (void)showFromTabBar:(UITabBar *)view;
- (void)showFromBarButtonItem:(UIBarButtonItem *)item animated:(BOOL)animated;
- (void)showFromRect:(CGRect)rect inView:(UIView *)view animated:(BOOL)animated;
- (void)showInView:(UIView *)view;

@end
