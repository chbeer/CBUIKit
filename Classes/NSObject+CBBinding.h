//
//  NSObject+CBBinding.h
//  CBUIKit
//
//  Created by Christian Beer on 20.10.11.
//  Copyright (c) 2011 Christian Beer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (CBBinding)

- (void)cb_bind:(NSString *)binding toObject:(id)observableController withKeyPath:(NSString *)keyPath options:(NSDictionary *)options;
- (void)cb_unbind:(NSString *)binding;

@end
