//
//  CBUITableViewController.h
//  CBUIKit
//
//  Created by Christian Beer on 08.03.11.
//  Copyright 2011 Christian Beer. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CBUIViewController.h"

#import "CBUITableViewDataSource.h"

@interface CBUITableViewController : CBUIViewController <UITableViewDataSource,UITableViewDelegate> {
	UITableViewStyle _style;
    
    id<CBUITableViewDataSource> _dataSource; 
	UITableView *_tableView;
}

@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet id<CBUITableViewDataSource> dataSource; ;

- (id) initWithStyle:(UITableViewStyle)style;

- (BOOL) isTableEmpty;

@end