//
//  CBUITabView.m
//  CBUIKit
//
//  Created by Christian Beer on 28.12.10.
//  Copyright 2010 Christian Beer. All rights reserved.
//

#import "CBUITabView.h"

#define ROUNDED_CORNER_RADIUS 5

@implementation CBUITabView

@synthesize delegate;
@dynamic tabTitles;
@dynamic currentTabIndex;
@dynamic style;

- (void) setupView {
    style = self;
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self 
                                                                                           action:@selector(didTapInView:)];
    [self addGestureRecognizer:tapGestureRecognizer];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) return nil;

    [self setupView];
    
    return self;
}
- (instancetype) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (!self) return nil;
    
    [self setupView];
    
    return self;
}

- (instancetype) initWithFrame:(CGRect)frame titles:(NSArray*)titles {
    self = [self initWithFrame:frame];
    if (!self) return nil;
    
    tabTitles = [titles copy];
    
    return self;
}

- (void) drawTabInTabView:(CBUITabView*)tabView context:(CGContextRef)ctx rect:(CGRect)rect 
                    title:(NSString*)title state:(CBUITabState)state {
    CGFloat mix = CGRectGetMinX(rect);
    CGFloat max = CGRectGetMaxX(rect);
    CGFloat miy = CGRectGetMinY(rect);
    CGFloat may = CGRectGetMaxY(rect);
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, mix, may);
    CGPathAddLineToPoint(path, NULL, mix, miy + ROUNDED_CORNER_RADIUS);
    CGPathAddQuadCurveToPoint(path, NULL, mix, miy, mix + ROUNDED_CORNER_RADIUS, miy);
    CGPathAddLineToPoint(path, NULL, max - ROUNDED_CORNER_RADIUS, miy);
    CGPathAddQuadCurveToPoint(path, NULL, max, miy, max, miy + ROUNDED_CORNER_RADIUS);
    CGPathAddLineToPoint(path, NULL, max, may);
    
    UIColor *fillColor, *textColor;
    switch (state) {
        case CBUITabStateDisabled:
            fillColor = [UIColor clearColor];
            textColor = [UIColor lightGrayColor];
            break;
        case CBUITabStateNormal:
            fillColor = [UIColor clearColor];
            textColor = [UIColor whiteColor];
            break;
        case CBUITabStateActive:
            fillColor = [UIColor lightGrayColor];
            textColor = [UIColor darkGrayColor];
            break;
        default:
            break;
    }
    
    CGContextAddPath(ctx, path);
    
    [fillColor setFill];
    [[UIColor whiteColor] setStroke];
    CGContextDrawPath(ctx, kCGPathFillStroke);
    
    CGPathRelease(path);
    
    [textColor set];
    UIFont *titleFont = [UIFont boldSystemFontOfSize:12];
    CGSize titleSize = [title sizeWithFont:titleFont];
    CGPoint titlePoint = CGPointMake(CGRectGetMidX(rect) - (titleSize.width / 2), 
                                     CGRectGetMidY(rect) - (titleSize.height / 2));
    [title drawAtPoint:titlePoint withFont:titleFont];
}

- (CGFloat) tabWidth {
    CGFloat tabWidth = self.bounds.size.width / tabTitles.count;
    return tabWidth;
}

- (void) drawRect:(CGRect)rect {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGFloat tabWidth = [self tabWidth];
    
    __block CGRect tabRect = CGRectMake(0.0, 0.0, tabWidth, self.bounds.size.height);
    
    [tabTitles enumerateObjectsUsingBlock:^(id  __nonnull title, NSUInteger index, BOOL * __nonnull stop) {
        BOOL selected = (currentTabIndex == index);
        
        CBUITabState state = selected ? CBUITabStateActive : CBUITabStateNormal;
        
        [style drawTabInTabView:self
                        context:ctx 
                           rect:tabRect
                          title:title 
                          state:state];
        
        tabRect.origin.x += tabWidth;
    }];
}


- (void)dealloc {
    tabTitles = nil;
    if (style != self) {
        style = nil;
    }
    
}

#pragma mark UIGestureRecognizer

- (void) didTapInView:(UITapGestureRecognizer*)gestureRecognizer {
    CGFloat x = [gestureRecognizer locationInView:self].x;
    
    int index = x / [self tabWidth];
    
    if ([delegate respondsToSelector:@selector(tabView:didSelectTabWithIndex:)]) {
        [delegate tabView:self didSelectTabWithIndex:index];
    }
    
    [self setCurrentTabIndex:index animated:YES];
}

#pragma mark Accessors

- (NSArray *) tabTitles {
    return tabTitles; 
}
- (void) setTabTitles: (NSArray *) aTabTitles {
    if (tabTitles != aTabTitles) {
        tabTitles = [aTabTitles copy];
        
        [self setNeedsDisplay];
    }
}

- (int) currentTabIndex {
    return currentTabIndex;
}
- (void) setCurrentTabIndex:(int)aCurrentTabIndex animated:(BOOL)animated {
    if (currentTabIndex != aCurrentTabIndex) {
        currentTabIndex = aCurrentTabIndex;
        [self setNeedsDisplay];
    }
}
- (void) setCurrentTabIndex:(int)aCurrentTabIndex {
    [self setCurrentTabIndex:aCurrentTabIndex animated:NO];
}

- (id<CBUITabViewStyle>) style {
    return style; 
}
- (void) setStyle: (id<CBUITabViewStyle>) aStyle {
    if (style != aStyle) {
        style = aStyle;
        
        [self setNeedsDisplay];
    }
}

@end
