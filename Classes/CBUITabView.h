//
//  CBUITabView.h
//  CBUIKit
//
//  Created by Christian Beer on 28.12.10.
//  Copyright 2010 Christian Beer. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CBUITabView;

typedef enum {
    CBUITabStateDisabled = -1,
    CBUITabStateNormal = 0,
    CBUITabStateActive = 1,
} CBUITabState;

@protocol CBUITabViewDelegate <NSObject>

- (void) tabView:(CBUITabView*)tabView didSelectTabWithIndex:(int)index;

@end

@protocol CBUITabViewStyle <NSObject>

- (void) drawTabInTabView:(CBUITabView*)tabView context:(CGContextRef)ctx rect:(CGRect)rect title:(NSString*)title state:(CBUITabState)state;

@end



@interface CBUITabView : UIView <CBUITabViewStyle> {
    NSArray *tabTitles;
    int currentTabIndex;

    id<CBUITabViewDelegate> delegate;
    id<CBUITabViewStyle> style;
}

@property (nonatomic, copy) NSArray *tabTitles;
@property (nonatomic, assign) int currentTabIndex;
@property (nonatomic, assign) id<CBUITabViewDelegate> delegate;
@property (nonatomic, retain) id<CBUITabViewStyle> style;

- (id) initWithFrame:(CGRect)frame;
- (id) initWithFrame:(CGRect)frame titles:(NSArray*)titles;

- (void) setCurrentTabIndex:(int)aCurrentTabIndex animated:(BOOL)animated;

@end
