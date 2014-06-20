//
//  CBUIDisclosureTriangle.m
//  ArabianRaces2
//
//  Created by Christian Beer on 20.01.11.
//  Copyright 2011 Christian Beer. All rights reserved.
//

#import "CBUIDisclosureTriangle.h"


@implementation CBUIDisclosureTriangle

@synthesize state;

- (instancetype)initWithFrame:(CGRect)frame {
    
    CGFloat edgeLength = MIN(frame.size.width, frame.size.height);
    frame = CGRectMake(CGRectGetMidX(frame) - edgeLength / 2, 
                       CGRectGetMidY(frame) - edgeLength / 2, 
                       edgeLength, edgeLength);
    
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextMoveToPoint(ctx, 0.0, 0.0);
    CGContextAddLineToPoint(ctx, CGRectGetMaxX(self.bounds), CGRectGetMidY(self.bounds));
    CGContextAddLineToPoint(ctx, 0.0, CGRectGetMaxY(self.bounds));
    CGContextClosePath(ctx);
    
    [[UIColor grayColor] set];
    CGContextFillPath(ctx);
}


- (void) setFrame:(CGRect)frame {
    CGFloat edgeLength = MIN(frame.size.width, frame.size.height);
    self.bounds = CGRectMake(0.0, 0.0, edgeLength, edgeLength);
    self.center = CGPointMake(CGRectGetMidX(frame), CGRectGetMidY(frame));
}

#pragma mark -

- (void) setState:(BOOL)aState animated:(BOOL)animated {
    if (aState != state) {
        state = aState;
        if (animated) {
            [UIView beginAnimations:@"rotate" 
                            context:nil];
        }
        
        if (state) {
            self.transform = CGAffineTransformMakeRotation(M_PI_2);
        } else {
            self.transform = CGAffineTransformIdentity;
        }
        
        
        if (animated) {
            [UIView commitAnimations];
        }
    }
}

- (void) setState:(BOOL)aState {
    [self setState:aState animated:NO];
}

@end
