//
//  CBUIGlobal.h
//  ArabianRaces2
//
//  Created by Christian Beer on 20.12.10.
//  Copyright 2010 Christian Beer. All rights reserved.
//

#import <UIKit/UIKit.h>

extern inline double CBUIRadians (double degrees);


BOOL CBIsIPad();
BOOL CBIsIOS7();

UIBarButtonItem *CBUIBarButtonSetTintColor(UIBarButtonItem *itm, UIColor *tintColor);
UIBarButtonItem *CBUIBarButtonSetStyle(UIBarButtonItem *itm, UIBarButtonItemStyle style);
UIBarButtonItem *CBUIBarButtonSetAccessibilityIdentifier(UIBarButtonItem *itm, NSString *accessibilityIdentifier);
UIBarButtonItem *CBUIBarFlexibleSpace();
UIBarButtonItem *CBUIBarButtonFixedSpace(CGFloat width);
UIBarButtonItem *CBUIBarButtonSystemItem(UIBarButtonSystemItem type, id target, SEL action);
UIBarButtonItem *CBUIBarButtonTextItem(NSString *title, id target, SEL action);
UIBarButtonItem *CBUIBarButtonImageItem(NSString *img, id target, SEL action);
UIBarButtonItem *CBUIBarButtonCustomItem(UIView *view);

#pragma mark -
#pragma mark Internationalization

NSString *I18N(NSString *key, NSString *comment);
NSString *I18N1(NSString *key, id param1);
NSString *I18N2(NSString *key, id param1, id param2);



CF_IMPLICIT_BRIDGING_ENABLED

CGPathRef CreateRoundedRectPath(CGRect rect, CGFloat radius);


void ShowNetworkIndicator();
void HideNetworkIndicator();


BOOL CBUIMinimumVersion(float version);

CGPoint CBCGPointDelta(CGPoint point, CGFloat deltaX, CGFloat deltaY);
CGPoint CBCGPointSetX(CGPoint point, CGFloat x);
CGPoint CBCGPointSetY(CGPoint point, CGFloat y);


CGRect CBCGRectOriginDelta(CGRect rect, CGFloat deltaX, CGFloat deltaY);
CGRect CBCGRectSizeDelta(CGRect rect, CGFloat deltaW, CGFloat deltaH);
CGRect CBCGRectSetX(CGRect rect, CGFloat x);
CGRect CBCGRectSetY(CGRect rect, CGFloat y);
CGRect CBCGRectSetWidth(CGRect rect, CGFloat w);
CGRect CBCGRectSetHeight(CGRect rect, CGFloat h);
CGRect CBCGRectInset(CGRect rect, CGFloat top, CGFloat left, CGFloat bottom, CGFloat right);
CGPoint CBCGRectGetCenter(CGRect rect);
CGRect CBCGRectSetCenter(CGRect rect, CGPoint center);
CGRect CBCGRectSetOrigin(CGRect rect, CGPoint origin);
CGRect CBCGRectSetSize(CGRect rect, CGSize size);
void CBCGRectSplit(CGRect rect, CGRect resultRects[], size_t size, BOOL vertical);

typedef CGRect(^CBCGRectModifyBlock)(CGRect rect);
CGRect CBCGRectModify(CGRect rect, CBCGRectModifyBlock modifyBlock);

CGRect CBCGRectFitAspect(CGRect rect, CGSize bounds);

CGSize CBCGSizeDelta(CGSize size, CGFloat deltaW, CGFloat deltaH);
CGSize CBCGSizeFitAspect(CGSize aspectRatio, CGSize boundingSize);
CGSize CBCGSizeFillAspect(CGSize aspectRatio, CGSize minimumSize);

CGPathRef CBCreateCGPathWithRect(CGRect rect);

CF_IMPLICIT_BRIDGING_DISABLED

