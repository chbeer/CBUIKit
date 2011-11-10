//
//  CBUIVerticalLayoutView.m
//  CBUIKit
//
//  Created by Christian Beer on 09.11.11.
//  Copyright (c) 2011 Christian Beer. All rights reserved.
//

#import "CBUIVerticalLayoutView.h"

@implementation CBUIVerticalLayoutView

@synthesize insets = _insets;

- (id)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (!self) return nil;
    
    self.insets = UIEdgeInsetsZero;
    self.autoresizesSubviews = YES;
    
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) return nil;
    
    self.insets = UIEdgeInsetsZero;
    self.autoresizesSubviews = YES;
    
    return self;
}

- (void)layoutSubviews
{
    __block CGFloat heightSum = 0.0;

    CGFloat contentWidth = self.bounds.size.width - self.insets.left - self.insets.right;
    CGFloat contentHeight = self.bounds.size.height - self.insets.top - self.insets.bottom;
    
    NSMutableArray *flexibleViews = [NSMutableArray array];
    [self.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIView *view = obj;
        
        if (view.hidden || view.alpha == 0.0) return;
        
        heightSum += view.bounds.size.height;
        
        if (view.autoresizingMask & UIViewAutoresizingFlexibleHeight) {
            [flexibleViews addObject:view];
        }
    }];
    
    if (heightSum != contentHeight && flexibleViews.count > 0) {
        CGFloat delta = contentHeight - heightSum;
        delta = delta / flexibleViews.count;
        
        [flexibleViews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            UIView *view = obj;
            
            CGRect bounds = view.bounds;
            bounds.size.height += delta;
            view.bounds = bounds;
        }];
    }
    
    // // Position views // // 
    
    __block CGFloat y = self.insets.top;
    
    [self.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIView *view = obj;
        
        if (view.hidden || view.alpha == 0.0) return;
        
        CGRect frame = view.bounds;
        frame.origin.x = self.insets.left;
        frame.origin.y = y;
        if (view.autoresizingMask & UIViewAutoresizingFlexibleWidth) {
            frame.size.width = contentWidth;
        }
        view.frame = CGRectIntegral(frame);
        
        y += view.bounds.size.height;
    }];
}

#pragma mark - 

- (void)setInsetsString:(NSString *)insetsString
{
    NSArray *components = [insetsString componentsSeparatedByString:@","];
    UIEdgeInsets insets = UIEdgeInsetsZero;
    if (components.count > 0) {
        insets.top = [[components objectAtIndex:0] floatValue];
    }
    if (components.count > 1) {
        insets.left = [[components objectAtIndex:1] floatValue];
    }
    if (components.count > 2) {
        insets.bottom = [[components objectAtIndex:2] floatValue];
    }
    if (components.count > 3) {
        insets.right = [[components objectAtIndex:3] floatValue];
    }
    self.insets = insets;
}

@end
