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

@interface CBUITableViewController : CBUIViewController <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) IBOutlet UITableView *tableView;

@property (nonatomic, assign) BOOL clearsSelectionOnViewWillAppear;

- (instancetype) initWithStyle:(UITableViewStyle)style;

@end