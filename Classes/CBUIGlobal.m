//
//  CBUIGlobal.m
//  ArabianRaces2
//
//  Created by Christian Beer on 20.12.10.
//  Copyright 2010 Christian Beer. All rights reserved.
//

#import "CBUIGlobal.h"
#include <math.h>

BOOL CBIsIPad() {
    return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
}

#pragma mark BarButtons

UIBarButtonItem *CBUIBarButtonSetStyle(UIBarButtonItem *itm, UIBarButtonItemStyle style) {
    itm.style = style;
    return itm;
}
UIBarButtonItem *CBUIBarButtonSetTintColor(UIBarButtonItem *itm, UIColor *tintColor)
{
    itm.tintColor = tintColor;
    return itm;
}


UIBarButtonItem *CBUIBarFlexibleSpace() {
	return [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
														  target:nil action:nil];
}
UIBarButtonItem *CBUIBarButtonFixedSpace(CGFloat width) {
	UIBarButtonItem *fs = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                        target:nil action:nil];
	fs.width = width;
	return fs;
}

UIBarButtonItem *CBUIBarButtonSystemItem(UIBarButtonSystemItem type, id target, SEL action) {
	UIBarButtonItem *itm = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:type
																		 target:target 
																		 action:action];
	return itm;
}
UIBarButtonItem *CBUIBarButtonTextItem(NSString *title, id target, SEL action) {
	UIBarButtonItem *itm = [[UIBarButtonItem alloc] initWithTitle:title
															style:UIBarButtonItemStyleBordered
														   target:target
														   action:action];
	return itm;
}
UIBarButtonItem *CBUIBarButtonImageItem(NSString *img, id target, SEL action) {
	UIBarButtonItem *itm = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:img] 
															style:UIBarButtonItemStylePlain
														   target:target
														   action:action];
	return itm;
}
UIBarButtonItem *CBUIBarButtonCustomItem(UIView *view) {
	UIBarButtonItem *itm = [[UIBarButtonItem alloc] initWithCustomView:view];
	return itm;
}

#pragma mark -
#pragma mark Internationalization

NSString *I18N(NSString *key, NSString *comment) {
	return NSLocalizedString(key, comment);
}
NSString *I18N1(NSString *key, id param1) {
	return [NSString stringWithFormat:NSLocalizedString(key, @""), param1];
}
NSString *I18N2(NSString *key, id param1, id param2) {
	return [NSString stringWithFormat:NSLocalizedString(key, @""), param1, param2];
}

#pragma mark -

CGPathRef CreateRoundedRectPath(CGRect rect, CGFloat radius) {
    CGFloat minx = CGRectGetMinX(rect), midx = CGRectGetMidX(rect), maxx = CGRectGetMaxX(rect); 
    CGFloat miny = CGRectGetMinY(rect), midy = CGRectGetMidY(rect), maxy = CGRectGetMaxY(rect); 
    
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGPathMoveToPoint(path, nil, minx, midy); 
    // Add an arc through 2 to 3 
    CGPathAddArcToPoint(path, nil, minx, miny, midx, miny, radius); 
    // Add an arc through 4 to 5 
    CGPathAddArcToPoint(path, nil, maxx, miny, maxx, midy, radius); 
    // Add an arc through 6 to 7 
    CGPathAddArcToPoint(path, nil, maxx, maxy, midx, maxy, radius); 
    // Add an arc through 8 to 9 
    CGPathAddArcToPoint(path, nil, minx, maxy, minx, midy, radius);
    // Close the path 
    CGPathCloseSubpath(path);
    
    return path;
}

#pragma mark -

static int networkIndicatorCounter = 0;
void ShowNetworkIndicator() 
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    networkIndicatorCounter++;
}
void HideNetworkIndicator()
{
    networkIndicatorCounter--;
    if (networkIndicatorCounter <= 0) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }
}

inline double CBUIRadians (double degrees) {return degrees * M_PI/180;}


BOOL CBUIMinimumVersion(float version)
{
    float iOSVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    return (iOSVersion >= version);
}


CGPoint CBCGPointDelta(CGPoint point, CGFloat deltaX, CGFloat deltaY)
{
    CGPoint result = point;
    result.x += deltaX;
    result.y += deltaY;
    return result;
}
CGPoint CBCGPointSetX(CGPoint point, CGFloat x)
{
    CGPoint result = point;
    result.x = x;
    return result;
}
CGPoint CBCGPointSetY(CGPoint point, CGFloat y)
{
    CGPoint result = point;
    result.y = y;
    return result;
}

CGRect CBCGRectOriginDelta(CGRect rect, CGFloat deltaX, CGFloat deltaY)
{
    rect.origin.x += deltaX;
    rect.origin.y += deltaY;
    return rect;
}
CGRect CBCGRectSizeDelta(CGRect rect, CGFloat deltaW, CGFloat deltaH)
{
    rect.size.width += deltaW;
    rect.size.height += deltaH;
    return rect;
}
CGRect CBCGRectSetX(CGRect rect, CGFloat x)
{
    rect.origin.x = x;
    return rect;
}
CGRect CBCGRectSetY(CGRect rect, CGFloat y)
{
    rect.origin.y = y;
    return rect;
}
CGRect CBCGRectSetWidth(CGRect rect, CGFloat w)
{
    rect.size.width = w;
    return rect;
}
CGRect CBCGRectSetHeight(CGRect rect, CGFloat h)
{
    rect.size.height = h;
    return rect;
}
CGPoint CBCGRectGetCenter(CGRect rect) {
    return CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
}

CGRect CBCGRectModify(CGRect rect, CBCGRectModifyBlock modifyBlock)
{
    return modifyBlock(rect);
}

CGRect CBCGRectFitAspect(CGRect rect, CGSize size)
{
    if (rect.size.width <= size.width && rect.size.height <= size.height) return rect;
    rect.size = CBCGSizeFitAspect(rect.size, size);
    return rect;
}
CGSize CBCGSizeFitAspect(CGSize size, CGSize fit)
{
    if (size.width <= fit.width && size.height <= fit.height) return size;
    CGFloat ar = size.width / size.height;
    CGFloat newAR = fit.width / fit.height;
    if (ar > newAR) {
        size.width = fit.width;
        size.height = fit.width / ar;
    } else {
        size.height = fit.height;
        size.width = fit.height * ar;
    }
    return size;
}