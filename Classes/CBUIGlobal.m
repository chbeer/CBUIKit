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

BOOL CBIsIOS7()
{
    float version = [[UIDevice currentDevice].systemVersion floatValue];
    return (version >= 7.0);
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
UIBarButtonItem *CBUIBarButtonSetAccessibilityIdentifier(UIBarButtonItem *itm, NSString *accessibilityIdentifier)
{
    itm.accessibilityIdentifier = accessibilityIdentifier;
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
															style:UIBarButtonItemStylePlain
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
    itm.width = view.bounds.size.width;
	return itm;
}

#pragma mark -
#pragma mark Internationalization

NSString *I18N(NSString *key, NSString *comment) {
#ifdef DEBUG
	NSString *i18n = [[NSBundle mainBundle] localizedStringForKey:key value:@"" table:nil];
    if (!i18n || [@"" isEqual:i18n]) {
        NSLog(@"[i18n] missing key: '%@'", key);
        i18n = [key uppercaseString];
    }
    return i18n;
#else
    return [[NSBundle mainBundle] localizedStringForKey:key value:@"" table:nil];
#endif
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

CGRect CBCGRectInset(CGRect rect, CGFloat top, CGFloat left, CGFloat bottom, CGFloat right)
{
    CGFloat deltaWidth = left + right;
    CGFloat deltaHeight = top + bottom;
    rect.origin.x += left;
    rect.origin.y += top;
    rect.size.width -= deltaWidth;
    rect.size.height -= deltaHeight;
    return rect;
}

CGPoint CBCGRectGetCenter(CGRect rect) {
    return CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
}
CGRect CBCGRectSetCenter(CGRect rect, CGPoint center)
{
    rect.origin.x = center.x - rect.size.width / 2;
    rect.origin.y = center.y - rect.size.height / 2;
    return rect;
}

CGRect CBCGRectSetOrigin(CGRect rect, CGPoint origin)
{
    rect.origin = origin;
    return rect;
}
CGRect CBCGRectSetSize(CGRect rect, CGSize size)
{
    rect.size = size;
    return rect;
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

void CBCGRectSplit(CGRect source, CGRect resultRects[], size_t size, BOOL vertical)
{
    CGFloat amount = vertical ? source.size.height / size : source.size.width / size;
    CGFloat current = vertical ? source.origin.y / size : source.origin.x;
    for (NSInteger index = 0; index < size; index++) {
        CGRect rect = resultRects[index];
        if (vertical) {
            rect.origin.x = source.origin.x;
            rect.origin.y = current;
            rect.size.width = CGRectGetWidth(source);
            rect.size.height = amount;
        } else {
            rect.origin.x = current;
            rect.origin.y = source.origin.y;
            rect.size.width = amount;
            rect.size.height = CGRectGetHeight(source);
        }
        current += amount;
    }
}

CGSize CBCGSizeDelta(CGSize size, CGFloat deltaW, CGFloat deltaH)
{
    size.width += deltaW;
    size.height += deltaH;
    return size;
}

CGSize CBCGSizeFitAspect(CGSize aspectRatio, CGSize boundingSize)
{
    if (aspectRatio.width <= boundingSize.width && aspectRatio.height <= boundingSize.height) return aspectRatio;
    
    float mW = boundingSize.width / aspectRatio.width;
    float mH = boundingSize.height / aspectRatio.height;
    if( mH < mW )
        boundingSize.width = boundingSize.height / aspectRatio.height * aspectRatio.width;
    else if( mW < mH )
        boundingSize.height = boundingSize.width / aspectRatio.width * aspectRatio.height;
    return boundingSize;
}
CGSize CBCGSizeFillAspect(CGSize aspectRatio, CGSize minimumSize)
{
    float mW = minimumSize.width / aspectRatio.width;
    float mH = minimumSize.height / aspectRatio.height;
    if( mH > mW )
        minimumSize.width = minimumSize.height / aspectRatio.height * aspectRatio.width;
    else if( mW > mH )
        minimumSize.height = minimumSize.width / aspectRatio.width * aspectRatio.height;
    return minimumSize;
}

CGPathRef CBCreateCGPathWithRect(CGRect rect)
{
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, rect);
    return path;
}

