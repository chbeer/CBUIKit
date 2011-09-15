//
//  CBUICircularProgressView.m
//  CBUIKit
//
//  Created by Christian Beer on 15.09.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "CBUICircularProgressView.h"

@implementation CBUICircularProgressView

@synthesize progress = _progress;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGFloat radius = MIN(self.bounds.size.width, self.bounds.size.height) / 2;
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGFloat endAngle = -M_PI_2 + (self.progress * 2 * M_PI);
    
    [[UIColor blueColor] set];
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:self.center];
    [path addLineToPoint:CGPointMake(self.center.x, 0)];
    [path addArcWithCenter:self.center radius:radius 
                startAngle:-M_PI_2 endAngle:endAngle clockwise:YES];
    [path closePath];
    [path fill];
    
    path = [UIBezierPath bezierPathWithArcCenter:self.center radius:radius 
                                      startAngle:0.0 endAngle:2 * M_PI clockwise:YES];
    [path stroke];
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
