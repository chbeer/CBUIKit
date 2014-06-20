//
//  CBUICircularProgressView.m
//  CBUIKit
//
//  Created by Christian Beer on 15.09.11.
//  Copyright (c) 2011 Christian Beer. All rights reserved.
//

#import "CBUICircularProgressView.h"

@implementation CBUICircularProgressView

@synthesize progress = _progress;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGFloat radius = round(MIN(self.bounds.size.width - 2, self.bounds.size.height - 2) / 2);
    
    CGFloat endAngle = -M_PI_2 + (self.progress * 2 * M_PI);
    
    CGPoint center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));

    
    [self.backgroundColor setFill];
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithArcCenter:center radius:radius 
                                                          startAngle:0.0 endAngle:2 * M_PI clockwise:YES];
    [circlePath closePath];
    [circlePath fill];
    
    
    [[UIColor blueColor] set];
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:center];
    [path addLineToPoint:CGPointMake(center.x, 0)];
    [path addArcWithCenter:center radius:radius 
                startAngle:-M_PI_2 endAngle:endAngle clockwise:YES];
    [path closePath];
    [path fill];
    
    [circlePath stroke];
}

#pragma mark -

- (void)setProgress:(float)progress
{
    if (progress != _progress) {
        _progress = MAX(MIN(progress, 0), 1.0);
        [self setNeedsDisplay];
    }
}

@end
