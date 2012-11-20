//
//  CBUIManyFetchResultsDataSource.h
//  CBUIKit
//
//  Created by Christian Beer on 10.07.12.
//  Copyright (c) 2012 Christian Beer. All rights reserved.
//

#import "CBUITableViewDataSource.h"
#import <CoreData/CoreData.h>

#import "CBUITableViewDataSource.h"


@interface CBUIManyFetchResultsDataSource : CBUITableViewDataSource <NSFetchedResultsControllerDelegate>

@property (readonly, strong)  NSArray       *sections;
@property (nonatomic, strong) NSIndexPath   *ignoreForUpdateIndexPath;

@property (nonatomic, assign) BOOL          preserveSelectionOnUpdate;

@property (nonatomic, assign) BOOL          allowsDeletion;

- (id) initWithTableView:(UITableView*)tableView;

- (BOOL) performFetch:(NSError**)error;

- (void) addSectionWithTitle:(NSString*)title
                fetchRequest:(NSFetchRequest*)fetchRequest managedObjectContext:(NSManagedObjectContext*)context;

@end


@interface CBUIManyFetchResultsSection : NSObject

@property (nonatomic, copy)     NSString *title;
@property (nonatomic, strong)   NSFetchedResultsController *fetchedResultsController;

- (id) objectAtRow:(NSUInteger)row;

@end