//
//  CBUIGlobal.h
//  ArabianRaces2
//
//  Created by Christian Beer on 20.12.10.
//  Copyright 2010 Christian Beer. All rights reserved.
//

#import <Foundation/Foundation.h>

// loglevel: 0 = debug, 1 = info, 2  = warning, 3 = error

/*#ifdef LOGLEVEL >= 0
#define DLog(...) NSLog(__VA_ARGS__)
#else
#define DLog(...)     /* */
//#endif

#ifdef LOGLEVEL >= 1
#define ILog(...) NSLog(__VA_ARGS__)
#else
#define ILog(...)     /* */
#endif


BOOL CBIsIPad();


UIBarButtonItem *CBUIBarButtonSetStyle(UIBarButtonItem *itm, UIBarButtonItemStyle style);
UIBarButtonItem *CBUIBarFlexibleSpace();
UIBarButtonItem *CBUIBarButtonFixedSpace(CGFloat width);
UIBarButtonItem *CBUIBarButtonSystemItem(UIBarButtonSystemItem type, id target, SEL action);
UIBarButtonItem *CBUIBarButtonTextItem(NSString *title, id target, SEL action);
UIBarButtonItem *CBUIBarButtonImageItem(NSString *img, id target, SEL action);
UIBarButtonItem *CBUIBarButtonCustomItem(UIView *view);

#pragma mark -
#pragma mark Internationalization

NSString *I18N(NSString *key);
NSString *I18N1(NSString *key, id param1);
NSString *I18N2(NSString *key, id param1, id param2);


CGPathRef CreateRoundedRectPath(CGRect rect, CGFloat radius);


void ShowNetworkIndicator();
void HideNetworkIndicator();