//
//  CBUIPanelView.m
//  CBUIKit
//
//  Created by Christian Beer on 28.12.10.
//  Copyright 2010 Christian Beer. All rights reserved.
//

#import "CBUIPanelView.h"


@implementation CBUIPanelView

@dynamic views;

- (void) awakeFromNib {
    [super awakeFromNib];
    if (self.subviews.count > 0) {
        currentView = (self.subviews)[0];
        
        for (UIView *view in self.subviews) {
            view.alpha = (view == currentView) ? 1.0 : 0.0;
        }
    }
}

- (void) dealloc {
    views = nil;
    
}

#pragma mark Accessors

- (NSArray *) views {
    return views; 
}
- (void) setViews: (NSArray *) aViews {
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];

    for (UIView *view in aViews) {
        [self addSubview:view];
        view.alpha = 0.0;
    }
    
    if (![self.subviews containsObject:currentView]) {
        if (self.subviews > 0) {
            currentView = (self.subviews)[0];
            currentView.alpha = 1.0;
        } else {
            currentView = nil;
        }
    }
}

- (NSUInteger) currentViewIndex {
    return [self.subviews indexOfObject:currentView];
}
- (void) setCurrentViewIndex:(int)viewIndex animated:(BOOL)animated {
    if (viewIndex < 0 || viewIndex >= self.subviews.count) return;
    
    UIView *oldView = currentView;
    UIView *newView = (self.subviews)[viewIndex];
    
    if (oldView != newView) {
        if (animated) {
            [UIView beginAnimations:@"switchViews" context:nil];
        }
        
        oldView.alpha = 0.0;
        newView.alpha = 1.0;
         
        if (animated) {
            [UIView commitAnimations];
        }
        
        currentView = newView;
    }
}
- (void) setCurrentViewIndex:(int)viewIndex {
    [self setCurrentViewIndex:viewIndex animated:NO];
}

@end
