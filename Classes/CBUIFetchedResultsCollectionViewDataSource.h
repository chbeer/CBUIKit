//
//  CBUIFetchedResultsCollectionViewDataSource.h
//  CBUIKit
//
//  Created by Christian Beer on 05.10.12.
//
//

#import "CBUICollectionViewDataSource.h"
#import <CoreData/CoreData.h>

@interface CBUIFetchedResultsCollectionViewDataSource : CBUICollectionViewDataSource

@property (readonly)            NSFetchedResultsController  *fetchedResultsController;

- (id) initWithCollectionView:(UICollectionView*)collectionView
                 fetchRequest:(NSFetchRequest*)fetchRequest managedObjectContext:(NSManagedObjectContext*)context
           sectionNameKeyPath:(NSString*)sectionNameKeyPath
                    cacheName:(NSString*)cacheName;
- (id) initWithCollectionView:(UICollectionView*)collectionView
                 fetchRequest:(NSFetchRequest*)fetchRequest
         managedObjectContext:(NSManagedObjectContext*)context
                    cacheName:(NSString*)cacheName;

+ (CBUIFetchedResultsCollectionViewDataSource*) dataSourceWithCollectionView:(UICollectionView*)collectionView
                                                                fetchRequest:(NSFetchRequest*)fetchRequest
                                                        managedObjectContext:(NSManagedObjectContext*)context
                                                          sectionNameKeyPath:(NSString*)sectionNameKeyPath
                                                                   cacheName:(NSString*)cacheName;
+ (CBUIFetchedResultsCollectionViewDataSource*) dataSourceWithCollectionView:(UICollectionView*)collectionView
                                                                fetchRequest:(NSFetchRequest*)fetchRequest
                                                        managedObjectContext:(NSManagedObjectContext*)context
                                                                   cacheName:(NSString*)cacheName;

- (BOOL) performFetch:(NSError**)error;

- (NSIndexPath*) indexPathForObject:(id)object;

@end
