//
//  CBUITableViewCellFactory.m
//
//  Created by Christian Beer on 10.01.11.
//  Copyright 2011 Christian Beer. All rights reserved.
//

#import "CBUITableViewCellFactory.h"

@interface CBUITableViewCellFactory ()
- (UITableViewCell*)cell;
@end



@implementation CBUITableViewCellFactory

+ (id) cellFromNibNamed:(NSString*)nibName {
    CBUITableViewCellFactory *factory = [[CBUITableViewCellFactory alloc] init];
    [[NSBundle mainBundle] loadNibNamed:nibName
                                  owner:factory 
                                options:nil];
    UITableViewCell *cell = [[factory cell] retain];
    [factory release];
    return [cell autorelease];
}

- (UITableViewCell*)cell {
    return cell;
}

@end
