//
//  CBUIHorizontalLayoutView.m
//  CBUIKit
//
//  Created by Christian Beer on 09.11.11.
//  Copyright (c) 2011 Christian Beer. All rights reserved.
//

#import "CBUIHorizontalLayoutView.h"

@implementation CBUIHorizontalLayoutView

@synthesize insets = _insets;
@synthesize spacing = _spacing;

- (id)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (!self) return nil;
    
    self.insets = UIEdgeInsetsZero;
    self.spacing= 0.0;
    self.autoresizesSubviews = NO;
    
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) return nil;
    
    self.insets = UIEdgeInsetsZero;
    self.spacing= 0.0;
    self.autoresizesSubviews = NO;
    
    return self;
}

- (void)layoutSubviews
{
    __block CGFloat widthSum = 0.0;

    CGFloat contentWidth = self.bounds.size.width - self.insets.left - self.insets.right;
    CGFloat contentHeight = self.bounds.size.height - self.insets.top - self.insets.bottom;
    
    NSMutableArray *flexibleViews = [NSMutableArray array];
    [self.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIView *view = obj;
        
        if (view.hidden || view.alpha == 0.0) return;
        
        widthSum += view.bounds.size.width;
        
        if (view.autoresizingMask & UIViewAutoresizingFlexibleWidth) {
            [flexibleViews addObject:view];
        }
    }];
    
    if (widthSum != contentWidth && flexibleViews.count > 0) {
        CGFloat delta = contentWidth - widthSum;
        delta = delta / flexibleViews.count;
        
        [flexibleViews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            UIView *view = obj;
            
            CGRect bounds = view.bounds;
            bounds.size.width += delta;
            view.bounds = bounds;
        }];
    }
    
    // // Position views // // 
    
    __block CGFloat x = self.insets.left;
    
    [self.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIView *view = obj;
        
        if (view.hidden || view.alpha == 0.0) return;
        
        CGRect frame = view.bounds;
        frame.origin.x = x;
        frame.origin.y = self.insets.top;
        if (view.autoresizingMask & UIViewAutoresizingFlexibleHeight) {
            frame.size.height = contentHeight;
        }
        view.frame = CGRectIntegral(frame);
        
        x += view.bounds.size.width + self.spacing;
        
        [view setNeedsLayout];
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
