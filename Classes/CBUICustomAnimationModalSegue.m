//
//  IVPushFromLeftModalSegue.m
//  iVocabulary
//
//  Created by Christian Beer on 29.09.12.
//
//

#import "CBUICustomAnimationModalSegue.h"

#import <QuartzCore/QuartzCore.h>
#import <objc/runtime.h>

static const char * kCBCustomModalPresentationSegueDismissAnimationBlock = "kCBCustomModalPresentationSegueDismissAnimationBlock";
typedef void(^CBCustomModalPresentationSegueDismissAnimationBlock)(void);


@interface CBUICustomAnimationModalSegue ()

@property (nonatomic, strong) NSString *transitionType;
@property (nonatomic, strong) NSString *transitionSubtype;

@property (nonatomic, strong) NSString *dismissTransitionType;
@property (nonatomic, strong) NSString *dismissTransitionSubtype;

@end


@interface UIViewController (CBUICustomAnimationModalSegue)

- (void)ivDismissViewControllerPushedFromRightAnimated:(BOOL)flag completion:(void (^)(void))completion;

@end


@implementation CBUICustomAnimationModalSegue

@synthesize transitionType = _transitionType;


- (void) perform
{
    UIViewController *src = (UIViewController *) self.sourceViewController;
    UIViewController *dst = (UIViewController *) self.destinationViewController;

    [CATransaction begin];
    
    CATransition *transition = [CATransition animation];
    transition.type = self.transitionType;
    transition.subtype = self.transitionSubtype;
    transition.duration = 0.25f;
    transition.fillMode = kCAFillModeForwards;
    transition.removedOnCompletion = YES;
    
    [[UIApplication sharedApplication].keyWindow.layer addAnimation:transition forKey:@"transition"];
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    [CATransaction setCompletionBlock: ^ {
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    }];
    
    __unsafe_unretained __block CBUICustomAnimationModalSegue *myself = self;
    NSString *transitionType = self.dismissTransitionType;
    NSString *transitionSubType = self.dismissTransitionSubtype;
    CBCustomModalPresentationSegueDismissAnimationBlock dismissAnimationBlock = ^{
        if (!myself) return;
        
        [CATransaction begin];
        
        CATransition *transition = [CATransition animation];
        transition.type = transitionType;
        transition.subtype = transitionSubType;
        transition.duration = 0.25f;
        transition.fillMode = kCAFillModeForwards;
        transition.removedOnCompletion = YES;
        
        [[UIApplication sharedApplication].keyWindow.layer addAnimation:transition forKey:@"transition"];
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        [CATransaction setCompletionBlock: ^ {
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        }];
    };
    
    UIViewController *ctrl = dst;
    if ([ctrl isKindOfClass:[UINavigationController class]]) ctrl = ((UINavigationController*)dst).topViewController;
    objc_setAssociatedObject(ctrl, kCBCustomModalPresentationSegueDismissAnimationBlock, dismissAnimationBlock, OBJC_ASSOCIATION_COPY);
    
    [src presentViewController:dst animated:NO completion:NULL];
    
    [CATransaction commit];
    
    static BOOL _didSwizzle = NO;
    if (!_didSwizzle) {
        Method origMethod = class_getInstanceMethod([UIViewController class], @selector(dismissViewControllerAnimated:completion:));
        Method overrideMethod = class_getInstanceMethod([UIViewController class], @selector(ivDismissViewControllerPushedFromRightAnimated:completion:));
        method_exchangeImplementations(origMethod, overrideMethod);
        _didSwizzle = YES;
    }
}

@end


@implementation CBUIPushFromRightModalSegue

- (instancetype)initWithIdentifier:(NSString *)identifier source:(UIViewController *)source destination:(UIViewController *)destination
{
    self = [super initWithIdentifier:identifier source:source destination:destination];
    if (!self) return nil;
    
    self.transitionType = kCATransitionPush;
    self.transitionSubtype = kCATransitionFromRight;
    
    self.dismissTransitionType = kCATransitionPush;
    self.dismissTransitionSubtype = kCATransitionFromLeft;
    
    return self;
}

@end

@implementation CBUIPushFromLeftModalSegue

- (instancetype)initWithIdentifier:(NSString *)identifier source:(UIViewController *)source destination:(UIViewController *)destination
{
    self = [super initWithIdentifier:identifier source:source destination:destination];
    if (!self) return nil;
    
    self.transitionType = kCATransitionPush;
    self.transitionSubtype = kCATransitionFromLeft;
    
    self.dismissTransitionType = kCATransitionPush;
    self.dismissTransitionSubtype = kCATransitionFromRight;
    
    return self;
}

@end


@implementation UIViewController (CBUICustomAnimationModalSegue)

- (void)ivDismissViewControllerPushedFromRightAnimated:(BOOL)flag completion:(void (^)(void))completion
{
    UIViewController *ctrl = self;
    if (self.presentingViewController) ctrl = self.presentingViewController;
    
    CBCustomModalPresentationSegueDismissAnimationBlock customAnimationBlock = objc_getAssociatedObject(self, kCBCustomModalPresentationSegueDismissAnimationBlock);
    
    if (customAnimationBlock) {
        customAnimationBlock();
        flag = NO;
    }
    
    // call super dismiss view controller; remember: we swizzled the methods
    [ctrl ivDismissViewControllerPushedFromRightAnimated:flag completion:completion];
    
    if (customAnimationBlock) {
        [CATransaction commit];
    }
}

@end