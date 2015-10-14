//
//  CBUISpring.h
//  CBUIKit
//
//  Created by Christian Beer on 08.11.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CBUISpringLayoutView;

@interface CBUISpring : NSObject 

@property (nonatomic, readonly) CGFloat minimum;
@property (nonatomic, readonly) CGFloat maximum;
@property (nonatomic, readonly) CGFloat preferred;

@property (nonatomic, assign) CGFloat value;
@property (nonatomic, assign) CGFloat strain;

- (BOOL) isCyclic:(CBUISpringLayoutView*)view;

@end

@interface CBUIAbstractSpring : CBUISpring {
    CGFloat _size;
}
- (void) clear;
@end

@interface CBUIStaticSpring : CBUIAbstractSpring 

- (id) initWithMinimum:(CGFloat)min preferred:(CGFloat)pref maximum:(CGFloat)max;
- (id) initWithPreferred:(CGFloat)pref;

@end

@interface CBUINegativeSpring : CBUISpring {
@private
    CBUISpring *_spring;
}
@end

@interface CBUIScaleSpring : CBUISpring {
@private
    CBUISpring *_spring;
    CGFloat     _factor;
}
@end

@interface CBUIWidthSpring : CBUIAbstractSpring {
@private
    UIView  *_view;
}
@end

@interface CBUIHeightSpring : CBUIAbstractSpring {
@private
    UIView  *_view;
}
@end