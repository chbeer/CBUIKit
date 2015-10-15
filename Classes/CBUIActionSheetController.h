//
//  CBUIActionSheetController.h
//  CBUIKit
//
//  Created by Christian Beer on 06.07.11.
//  Copyright 2011 Christian Beer. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CBUIActionSheetControllerButton;

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
typedef void(^CBUIActionSheetHandler)(UIActionSheet *actionSheet, NSUInteger buttonIndex);
#pragma clang diagnostic pop

NS_CLASS_DEPRECATED_IOS(2_0, 8_3, "CBUIActionSheetController is deprecated. Use UIAlertController instead")
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

- (instancetype) initWithTitle:(NSString*)inTitle;
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
