//
//  NSObject+CBBinding.m
//  CBUIKit
//
//  Created by Christian Beer on 20.10.11.
//  Copyright (c) 2011 Christian Beer. All rights reserved.
//

#import "NSObject+CBBinding.h"
#import <objc/runtime.h>

static char     * const CBBINDING_OBSERVER          = "__CBBINDING_OBSERVER";

@interface CBBindingManager : NSObject {
@private
}
@property (nonatomic, assign) id                   observer;
@property (nonatomic, retain) NSMutableDictionary *bindings;

- (void)cb_bind:(NSString *)binding toObject:(id)observableController withKeyPath:(NSString *)keyPath options:(NSDictionary *)options;
- (void)cb_unbind:(NSString *)binding;

@end

@interface CBBinding : NSObject 
@property (nonatomic, assign)   id               observer;
@property (nonatomic, assign)   id               observable;
@property (nonatomic, copy)     NSString        *observedKeyPath;
@property (nonatomic, copy)     NSString        *boundKeyPath;
@property (nonatomic, retain)   NSDictionary    *options;
@end

@implementation NSObject (CBBinding)

- (void)cb_bind:(NSString *)binding toObject:(id)observableController withKeyPath:(NSString *)keyPath options:(NSDictionary *)options;
{
    CBBindingManager *observer = objc_getAssociatedObject(self, CBBINDING_OBSERVER);
    if (!observer) {
        observer = [[CBBindingManager alloc] init];
        observer.observer = self;
        objc_setAssociatedObject(self, CBBINDING_OBSERVER, observer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [observer release];
    }
    
    [observer cb_bind:binding toObject:observableController withKeyPath:keyPath options:options];
}

- (void)cb_unbind:(NSString *)binding;
{
    CBBindingManager *observer = objc_getAssociatedObject(self, CBBINDING_OBSERVER);
    if (!observer) return;
    
    [observer cb_unbind:binding];
}

@end


@implementation CBBindingManager

@synthesize observer = _observer;
@synthesize bindings = _bindings;

- (void)dealloc {
    [self.bindings enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [self cb_unbind:key];
    }];
    
    [_bindings release], _bindings = nil;
    [super dealloc];
}

- (NSMutableDictionary*) bindings
{
    if (!_bindings) {
        _bindings = [[NSMutableDictionary alloc] init];
    }
    return _bindings;
}

- (void)cb_bind:(NSString *)bindingKeyPath toObject:(id)observableController withKeyPath:(NSString *)keyPath options:(NSDictionary *)options;
{
    if ([self.bindings objectForKey:bindingKeyPath]) {
        [self cb_unbind:bindingKeyPath];
    }
    
    CBBinding *binding = [[CBBinding alloc] init];
    binding.observer = self.observer;
    binding.boundKeyPath = bindingKeyPath;
    binding.observable = observableController;
    binding.observedKeyPath = keyPath;
    binding.options = options;
    
    [observableController addObserver:binding forKeyPath:keyPath options:NSKeyValueObservingOptionNew context:nil];
    [self.observer addObserver:binding forKeyPath:bindingKeyPath options:NSKeyValueObservingOptionNew context:nil];
    
    [self.bindings setObject:binding forKey:bindingKeyPath];
    [binding release];
}

- (void)cb_unbind:(NSString *)bindingKeyPath;
{
    [self.bindings removeObjectForKey:bindingKeyPath];
}

@end 


@implementation CBBinding

@synthesize observer = _observer;
@synthesize observable = _observable;
@synthesize observedKeyPath = _observedKeyPath;
@synthesize boundKeyPath = _boundKeyPath;
@synthesize options = _options;

- (void)dealloc {
    [_observer removeObserver:self forKeyPath:_boundKeyPath];
    [_observable removeObserver:self forKeyPath:_observedKeyPath];
    
    [_observedKeyPath release], _observedKeyPath = nil;
    [_boundKeyPath release], _boundKeyPath = nil;
    [_options release], _options = nil;

    [super dealloc];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    id newValue = [change objectForKey:NSKeyValueChangeNewKey];
    if ([newValue isKindOfClass:[NSNull class]]) newValue = nil;
    
    id obj = nil;
    NSString *path;
    if (object == self.observer) {
        obj = self.observable;
        path = self.observedKeyPath;
    } else if (object == self.observable) {
        obj = self.observer;
        path = self.boundKeyPath;
    }
    
    [obj removeObserver:self forKeyPath:path];
    [obj setValue:newValue forKeyPath:path];
    [obj addObserver:self forKeyPath:path options:NSKeyValueObservingOptionNew context:nil];
}

@end