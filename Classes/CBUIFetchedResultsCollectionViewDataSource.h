//
//  CBUIFetchedResultsCollectionViewDataSource.h
//  CBUIKit
//
//  Created by Christian Beer on 05.10.12.
//
//

#import "CBUICollectionViewDataSource.h"
#import <CoreData/CoreData.h>

@interface CBUIFetchedResultsCollectionViewDataSource : CBUICollectionViewDataSource <NSFetchedResultsControllerDelegate>

@property (readonly, strong)    NSFetchedResultsController  *fetchedResultsController;

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


@interface CBUIFetchedResultsCollectionViewUpdate : NSObject

@property (nonatomic, assign) NSFetchedResultsChangeType changeType;
@property (nonatomic, assign) BOOL          section;
@property (nonatomic, strong) NSIndexPath   *indexPath;
@property (nonatomic, strong) NSIndexPath   *theNewIndexPath;
@property (nonatomic, assign) NSUInteger    sectionIndex;

+ (CBUIFetchedResultsCollectionViewUpdate*) updateItemAtIndexPath:(NSIndexPath *)indexPath
                                                    forChangeType:(NSFetchedResultsChangeType)type
                                                     newIndexPath:(NSIndexPath *)newIndexPath;
+ (CBUIFetchedResultsCollectionViewUpdate*) updateSectionAtIndex:(NSUInteger)sectionIndex
                                                   forChangeType:(NSFetchedResultsChangeType)type;

- (void) performUpdateOnCollectionView:(UICollectionView*)collectionView;

@end
