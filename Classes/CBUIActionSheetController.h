//
//  CBUIActionSheetController.h
//  CBUIKit
//
//  Created by Christian Beer on 06.07.11.
//  Copyright 2011 Christian Beer. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CBUIActionSheetControllerButton;

typedef void(^CBUIActionSheetHandler)(UIActionSheet *actionSheet, NSUInteger buttonIndex);

@interface CBUIActionSheetController : NSObject <UIActionSheetDelegate> {
    
    UIActionSheet                       *actionSheet;
    
    NSString                            *title;
    
    CBUIActionSheetControllerButton     *cancelButton;
    CBUIActionSheetControllerButton     *destructiveButton;
    
    NSMutableArray                      *buttons;
    
}

@property (nonatomic, assign) UIActionSheetStyle actionSheetStyle;

+ (instancetype) actionSheetControllerWithTitle:(NSString*)title buttonsWithHandlerAndTitle:(CBUIActionSheetHandler)firstHandler, ...;
+ (instancetype) actionSheetControllerWithTitle:(NSString*)title;

- (id) applyCancelButtonTitle:(NSString*)title handler:(CBUIActionSheetHandler)handler;
- (id) applyDestructiveButtonTitle:(NSString*)title handler:(CBUIActionSheetHandler)handler;
- (id) applyButtonWithTitle:(NSString*)title handler:(CBUIActionSheetHandler)handler;

- (instancetype) initWithTitle:(NSString*)inTitle NS_DESIGNATED_INITIALIZER;
- (instancetype) initWithTitle:(NSString*)inTitle buttonsWithHandlerAndTitle:(CBUIActionSheetHandler)firstHandler, ...;

- (void) setCancelButtonTitle:(NSString*)title handler:(CBUIActionSheetHandler)handler;
- (void) setDestructiveButtonTitle:(NSString*)title handler:(CBUIActionSheetHandler)handler;
- (void) addButtonWithTitle:(NSString*)title handler:(CBUIActionSheetHandler)handler;

- (void)showFromToolbar:(UIToolbar *)view;
- (void)showFromTabBar:(UITabBar *)view;
- (void)showFromBarButtonItem:(UIBarButtonItem *)item animated:(BOOL)animated;
- (void)showFromRect:(CGRect)rect inView:(UIView *)view animated:(BOOL)animated;
- (void)showInView:(UIView *)view;

@end
