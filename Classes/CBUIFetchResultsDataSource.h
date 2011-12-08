//
//  CBUIFetchResultsDataSource.h
//  CBUIKit
//
//  Created by Christian Beer on 14.01.10.
//  Copyright 2010 Christian Beer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#import "CBUITableViewDataSource.h"

#import "SafeFetchedResultsController.h"

@interface CBUIFetchResultsDataSource : CBUITableViewDataSource <SafeFetchedResultsControllerDelegate> 

@property (readonly) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, assign, getter=isLoading) BOOL loading;
@property (nonatomic, retain) NSIndexPath *ignoreForUpdateIndexPath;

- (id) initWithTableView:(UITableView*)tableView
            fetchRequest:(NSFetchRequest*)fetchRequest managedObjectContext:(NSManagedObjectContext*)context 
      sectionNameKeyPath:(NSString*)sectionNameKeyPath
               cacheName:(NSString*)cacheName;
- (id) initWithTableView:(UITableView*)tableView
            fetchRequest:(NSFetchRequest*)fetchRequest managedObjectContext:(NSManagedObjectContext*)context 
               cacheName:(NSString*)cacheName;

+ (CBUIFetchResultsDataSource*) dataSourceWithTableView:(UITableView*)tableView
                                           fetchRequest:(NSFetchRequest*)fetchRequest managedObjectContext:(NSManagedObjectContext*)context
                                     sectionNameKeyPath:(NSString*)sectionNameKeyPath cacheName:(NSString*)cacheName;
+ (CBUIFetchResultsDataSource*) dataSourceWithTableView:(UITableView*)tableView fetchRequest:(NSFetchRequest*)fetchRequest 
                                   managedObjectContext:(NSManagedObjectContext*)context cacheName:(NSString*)cacheName;

- (NSIndexPath*) indexPathForObject:(id)object;

- (BOOL) performFetch:(NSError**)error;
// ONLY WORKS WITH ONE SECTION!!
- (BOOL) performFetchAndUpdateTableView:(NSError **)error;

@end


@interface CBUIFetchResultsByKeyPathDataSource : CBUIFetchResultsDataSource {
    NSString *objectKeyPath;
}

@property (nonatomic, copy) NSString *objectKeyPath;

@end