//
//  CBUISpring.m
//  CBUIKit
//
//  Created by Christian Beer on 08.11.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "CBUISpring.h"

#import "CBUISpringLayoutView.h"

// Modelled after javax.swing.Spring 
// see http://javasourcecode.org/html/open-source/jdk/jdk-6u23/javax/swing/Spring.java.html

static CGFloat kCBUIUnset = CGFLOAT_MAX;

@implementation CBUISpring

@dynamic minimum, maximum, preferred, value;

- (CGFloat) rangeWhenContracted:(BOOL)contract
{
    return contract ? ([self preferred] - [self minimum]) : ([self maximum] - [self preferred]);
}

- (CGFloat) strain 
{
    CGFloat delta = ([self value] - [self preferred]);
    return delta / [self rangeWhenContracted:([self value] < [self preferred])];
}

- (void) setStrain:(CGFloat) strain
{
    self.value = ([self preferred] + (strain * [self rangeWhenContracted:(strain < 0)]));
}

- (BOOL) isCyclic:(CBUISpringLayoutView*)view
{
    return false;
}

@end


@implementation CBUIAbstractSpring

- (CGFloat) value
{
    return _size != kCBUIUnset ? _size : [self preferred];
}

- (void) setValue:(CGFloat)size
{
    if (_size == size) {
        return; 
    }
    if (size == kCBUIUnset) {
        [self clear];
    } else {
        _size = size;
    }
}

- (void) clear
{
    _size = kCBUIUnset;
}

@end


@implementation CBUIStaticSpring

@synthesize minimum = _minimum;
@synthesize maximum = _maximum;
@synthesize preferred = _preferred;

- (id) initWithMinimum:(CGFloat)min preferred:(CGFloat)pref maximum:(CGFloat)max;
{
    self = [super init];
    if (!self) return nil;
    
    _minimum = min;
    _preferred = pref;
    _maximum = max;
    
    return self;
}
- (id) initWithPreferred:(CGFloat)pref;
{
    return [self initWithMinimum:pref preferred:pref maximum:pref];
}

@end

@implementation CBUINegativeSpring
    
- (id) initWithSpring:(CBUISpring*)inSpring
{
    self = [super init];
    if (!self) return nil;
    
    _spring = inSpring;
    
    return self;
}

- (void)dealloc {
    _spring = nil;
    
}

// Note the use of max value rather than minimum value here.
// See the opening preamble on arithmetic with springs.

- (CGFloat)minimum
{
    return -[_spring maximum];
}

- (CGFloat)preferred
{
    return -[_spring preferred];
}

- (CGFloat)maximum
{
    return -[_spring minimum];
}

- (CGFloat)value
{
    return -[_spring value];
}

- (void)setValue:(CGFloat)value
{
    [_spring setValue:-value];
}

- (BOOL)isCyclic:(CBUISpringLayoutView*)view
{
    return [_spring isCyclic:view];
}

@end


@implementation CBUIScaleSpring

- (id) initWithSpring:(CBUISpring*)inSpring factor:(CGFloat)factor
{
    self = [super init];
    if (!self) return nil;
    
    _spring = inSpring;
    _factor = factor;
    
    return self;
}

- (void)dealloc {
    _spring = nil;
    
}

- (CGFloat)minimum
{
    return (_factor < 0 ? [_spring maximum] : [_spring minimum]) * _factor;
}

- (CGFloat)preferred
{
    return [_spring preferred] * _factor;
}

- (CGFloat)maximum
{
    return (_factor < 0 ? [_spring minimum] : [_spring maximum]) * _factor;
}

- (CGFloat)value
{
    return [_spring value] * _factor;
}
    
- (void)setValue:(CGFloat)value
{
    if (value == kCBUIUnset) {
        [_spring setValue:kCBUIUnset];
    } else {
        [_spring setValue:(value / _factor)];
    }
}

- (BOOL)isCyclic:(CBUISpringLayoutView *)view
{
    return [_spring isCyclic:view];
}

@end


@implementation CBUIWidthSpring

- (id)initWithView:(UIView*)view {
    self = [super init];
    if (!self) return nil;
    
    _view = view;
    
    return self;
}

- (void)dealloc {
    _view = nil;
    
}

- (CGFloat) minimum
{
    return [_view bounds].size.width;
}

- (CGFloat) preferred
{
    return [_view bounds].size.width;
}

- (CGFloat) maximum
{
    return MIN(CGFLOAT_MAX, [_view bounds].size.width);
}

@end


@implementation CBUIHeightSpring

- (id)initWithView:(UIView*)view {
    self = [super init];
    if (!self) return nil;
    
    _view = view;
    
    return self;
}

- (void)dealloc {
    _view = nil;
    
}

- (CGFloat) minimum
{
    return [_view bounds].size.height;
}

- (CGFloat) preferred
{
    return [_view bounds].size.height;
}

- (CGFloat) maximum
{
    return MIN(CGFLOAT_MAX, [_view bounds].size.height);
}

@end
