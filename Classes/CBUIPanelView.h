//
//  CBUIPanelView.h
//  CBUIKit
//
//  Created by Christian Beer on 28.12.10.
//  Copyright 2010 Christian Beer. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CBUIPanelView : UIView {
    NSArray *views;
    UIView *currentView;
}

@property (nonatomic, copy) NSArray *views;


- (void) setCurrentViewIndex:(int) currentViewIndex animated:(BOOL)animated;

@end
