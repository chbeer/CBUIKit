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

@interface CBUIFetchResultsDataSource : CBUITableViewDataSource <NSFetchedResultsControllerDelegate> {

	NSFetchedResultsController  *_fetchedResultsController;
    
    BOOL                        _userDrivenChange;

}

@property (readonly) NSFetchedResultsController *fetchedResultsController;

@property (nonatomic, assign, getter=isUserDrivenChange) BOOL userDrivenChange;

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

@end


@interface CBUIFetchResultsByKeyPathDataSource : CBUIFetchResultsDataSource {
    NSString *objectKeyPath;
}

@property (nonatomic, copy) NSString *objectKeyPath;

@end