//
//  CBUITableViewCellFactory.h
//
//  Created by Christian Beer on 10.01.11.
//  Copyright 2011 Christian Beer. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CBUITableViewCellFactory : NSObject {
    IBOutlet UITableViewCell *cell;
}

+ (id) cellFromNibNamed:(NSString*)nibName;

@end
