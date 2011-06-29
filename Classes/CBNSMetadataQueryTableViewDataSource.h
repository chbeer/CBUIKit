//
//  CBNSMetadataQueryTableViewDataSource.h
//  CBUIKit
//
//  Created by Christian Beer on 29.06.11.
//  Copyright 2011 Christian Beer. All rights reserved.
//

#import "CBUITableViewDataSource.h"

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 50000  // available for iOS > 5.0

@interface CBNSMetadataQueryTableViewDataSource : CBUIArrayTableViewDataSource {
    NSMetadataQuery *_query;
}

@property (nonatomic, readonly) NSMetadataQuery *query;

// convenience methods

- (void) setSearchScopes:(NSArray*)searchScopes;
- (NSArray*) searchScopes;

- (void) setPredicate:(NSPredicate*)predicate;
- (NSPredicate*) predicate;

- (void) startQuery;

@end

#endif