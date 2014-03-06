//
//  CBUIRoundedCornerView.m
//  CBUIKit
//
//  Created by Christian Beer on 08.10.12.
//
//

#import "CBUIRoundedCornerView.h"

#import <QuartzCore/QuartzCore.h>

@implementation CBUIRoundedCornerView

@dynamic cornerRadius;
@dynamic borderColor;

- (void)setCornerRadius:(CGFloat)cornerRadius
{
    self.layer.cornerRadius = cornerRadius;
}
- (CGFloat)cornerRadius
{
    return self.layer.cornerRadius;
}

- (void)setBorderColor:(UIColor *)borderColor
{
    if (borderColor) {
        self.layer.borderWidth = 1.0;
        self.layer.borderColor = borderColor.CGColor;
    } else {
        self.layer.borderWidth = 0.0;
    }
}

@end
