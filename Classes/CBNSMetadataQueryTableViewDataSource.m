//
//  CBNSMetadataQueryTableViewDataSource.m
//  CBUIKit
//
//  Created by Christian Beer on 29.06.11.
//  Copyright 2011 Christian Beer. All rights reserved.
//

#import "CBNSMetadataQueryTableViewDataSource.h"

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 50000  // available for iOS > 5.0

@implementation CBNSMetadataQueryTableViewDataSource

@synthesize query = _query;

- (id)init {
    self = [super init];
    if (!self) return nil;
    
    _query = [[NSMetadataQuery alloc] init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(metadataQueryDidUpdateNotification:) 
                                                 name:NSMetadataQueryDidUpdateNotification 
                                               object:_query];
        
    return self;
}

- (void)dealloc {
    [_query release], _query = nil;
    
    [super dealloc];
}

#pragma mark -

- (void) startQuery
{
    [_query startQuery];
}

#pragma mark - Convenience Methods

- (void) setSearchScopes:(NSArray*)searchScopes;
{
    [_query setSearchScopes:searchScopes];
}
- (NSArray*) searchScopes;
{
    return [_query searchScopes];
}

- (void) setPredicate:(NSPredicate*)predicate;
{
    [_query setPredicate:predicate];
}
- (NSPredicate*) predicate;
{
    return [_query predicate];
}

#pragma mark - Notifications

- (void) metadataQueryDidUpdateNotification:(NSNotification*)notification
{
    [_query disableUpdates];
    
    
    
    [_query enableUpdates];
}

@end

#endif