//
//  CBUIActivityView.m
//  CBUIKit
//
//  Created by Christian Beer on 05.07.11.
//  Copyright 2011 Christian Beer. All rights reserved.
//

#import "CBUIActivityView.h"

@implementation CBUIActivityView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) return nil;
    
    self.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
    self.opaque = NO;
    
    
    
    return self;
}

@end
