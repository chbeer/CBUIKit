//
//  CBUIFetchedResultsCollectionViewDataSource.m
//  CBUIKit
//
//  Created by Christian Beer on 05.10.12.
//
//

#import "CBUIFetchedResultsCollectionViewDataSource.h"

#import "CBUIGlobal.h"
#import "CBUIFetchResultsDataSource.h"

@interface CBUIFetchedResultsCollectionViewDataSource ()

@property (readwrite, strong) NSFetchedResultsController    *fetchedResultsController;
@property (nonatomic, retain) NSMutableArray                *updates;

@end



@class CBUIFetchedResultsCollectionViewUpdate;

@implementation CBUIFetchedResultsCollectionViewDataSource


- (id) initWithCollectionView:(UICollectionView*)collectionView
            fetchRequest:(NSFetchRequest*)fetchRequest managedObjectContext:(NSManagedObjectContext*)context
      sectionNameKeyPath:(NSString*)sectionNameKeyPath
               cacheName:(NSString*)cacheName
{
	self = [super initWithCollectionView:collectionView];
    if (!self) return nil;
    
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                    managedObjectContext:context
                                                                      sectionNameKeyPath:sectionNameKeyPath
                                                                               cacheName:cacheName];
    self.fetchedResultsController.delegate = self;
    
    self.loading = NO;
    self.empty = YES;
    
	return self;
}
- (id) initWithCollectionView:(UICollectionView*)collectionView
                 fetchRequest:(NSFetchRequest*)fetchRequest
         managedObjectContext:(NSManagedObjectContext*)context
                    cacheName:(NSString*)cacheName
{
    return [self initWithCollectionView:collectionView
                           fetchRequest:fetchRequest
                   managedObjectContext:context
                     sectionNameKeyPath:nil
                              cacheName:cacheName];
}

+ (CBUIFetchedResultsCollectionViewDataSource*) dataSourceWithCollectionView:(UICollectionView*)collectionView
                                                                fetchRequest:(NSFetchRequest*)fetchRequest
                                                        managedObjectContext:(NSManagedObjectContext*)context
                                                          sectionNameKeyPath:(NSString*)sectionNameKeyPath
                                                                   cacheName:(NSString*)cacheName
{
	CBUIFetchedResultsCollectionViewDataSource *ds = [[[self class] alloc] initWithCollectionView:collectionView
                                                                                     fetchRequest:fetchRequest
                                                                             managedObjectContext:context
                                                                               sectionNameKeyPath:sectionNameKeyPath
                                                                                        cacheName:cacheName];
	
	return ds;
    
}

+ (CBUIFetchedResultsCollectionViewDataSource*) dataSourceWithCollectionView:(UICollectionView*)collectionView
                                                                fetchRequest:(NSFetchRequest*)fetchRequest
                                                        managedObjectContext:(NSManagedObjectContext*)context
                                                                   cacheName:(NSString*)cacheName
{
    return [self dataSourceWithCollectionView:collectionView
                                 fetchRequest:fetchRequest
                         managedObjectContext:context
                           sectionNameKeyPath:nil
                                    cacheName:cacheName];
}

- (void) dealloc {
    _fetchedResultsController.delegate = nil;
    _fetchedResultsController = nil;
    
}

- (BOOL) performFetch:(NSError**)error
{
    self.loading = YES;
    BOOL result = [_fetchedResultsController performFetch:error];

    self.loading = NO;
    [self.collectionView reloadData];
    
    self.empty = _fetchedResultsController.fetchedObjects.count == 0;
    
    return result;
}

#pragma mark UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
	return [[_fetchedResultsController sections] count];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
	id <NSFetchedResultsSectionInfo> sectionInfo = [[_fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

#pragma mark NSFetchedResultsControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
	self.updates = [[NSMutableArray alloc] init];
}

- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath
	 forChangeType:(NSFetchedResultsChangeType)type
	  newIndexPath:(NSIndexPath *)newIndexPath
{
    [self.updates addObject:[CBUIFetchedResultsCollectionViewUpdate updateItemAtIndexPath:indexPath
                                                                            forChangeType:type
                                                                             newIndexPath:newIndexPath]];
}

- (void)controller:(NSFetchedResultsController *)controller
  didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex
     forChangeType:(NSFetchedResultsChangeType)type
{
    [self.updates addObject:[CBUIFetchedResultsCollectionViewUpdate updateSectionAtIndex:sectionIndex
                                                                           forChangeType:type]];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    self.empty = _fetchedResultsController.fetchedObjects.count == 0;
    
	[self.collectionView performBatchUpdates:^{
        [self.updates enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            CBUIFetchedResultsCollectionViewUpdate *update = obj;
            [update performUpdateOnCollectionView:self.collectionView];
        }];
    } completion:^(BOOL finished) {
        self.updates = nil;
    }];
}

- (void)controllerDidMakeUnsafeChanges:(NSFetchedResultsController *)controller
{
	DLog(@"controllerDidMakeUnsafeChanges");
    
    self.empty = _fetchedResultsController.fetchedObjects.count == 0;
	
	[self.collectionView reloadData];
}

#pragma mark CBUICollectionViewDataSource

- (id) objectAtIndexPath:(NSIndexPath*)indexPath {
    NSManagedObject *managedObject = [self.fetchedResultsController objectAtIndexPath:indexPath];
	return managedObject;
}

#pragma mark -

- (NSIndexPath*) indexPathForObject:(id)object
{
    return [self.fetchedResultsController indexPathForObject:object];
}

@end



@implementation CBUIFetchedResultsCollectionViewUpdate

+ (CBUIFetchedResultsCollectionViewUpdate*) updateItemAtIndexPath:(NSIndexPath *)indexPath
                                                    forChangeType:(NSFetchedResultsChangeType)type
                                                     newIndexPath:(NSIndexPath *)newIndexPath
{
    CBUIFetchedResultsCollectionViewUpdate *update = [CBUIFetchedResultsCollectionViewUpdate new];
    update.indexPath = indexPath;
    update.changeType = type;
    update.theNewIndexPath = newIndexPath;
    return update;
}
+ (CBUIFetchedResultsCollectionViewUpdate*) updateSectionAtIndex:(NSUInteger)sectionIndex
                                                forChangeType:(NSFetchedResultsChangeType)type
{
    CBUIFetchedResultsCollectionViewUpdate *update = [CBUIFetchedResultsCollectionViewUpdate new];
    update.section = YES;
    update.sectionIndex = sectionIndex;
    update.changeType = type;
    return update;
}

- (void) performUpdateOnCollectionView:(UICollectionView*)collectionView;
{
    if (!self.section) {
        switch(self.changeType) {
            case NSFetchedResultsChangeInsert:
                [collectionView insertItemsAtIndexPaths:[NSArray arrayWithObject:self.theNewIndexPath]];
                break;
            case NSFetchedResultsChangeDelete:
                [collectionView deleteItemsAtIndexPaths:[NSArray arrayWithObject:self.indexPath]];
                break;
            case NSFetchedResultsChangeUpdate:
                if (self.theNewIndexPath == nil || [self.theNewIndexPath isEqual:self.indexPath]) {
                    [collectionView reloadItemsAtIndexPaths:[NSArray arrayWithObject:self.indexPath]];
                } else {
                    [collectionView moveItemAtIndexPath:self.indexPath
                                            toIndexPath:self.theNewIndexPath];
                }
                break;
            case NSFetchedResultsChangeMove:
                [collectionView moveItemAtIndexPath:self.indexPath
                                        toIndexPath:self.theNewIndexPath];
                break;
        }
        
    } else {
	
        switch(self.changeType) {
            case NSFetchedResultsChangeInsert:
                [collectionView insertSections:[NSIndexSet indexSetWithIndex:self.sectionIndex]];
                break;
            case NSFetchedResultsChangeDelete:
                [collectionView deleteSections:[NSIndexSet indexSetWithIndex:self.sectionIndex]];
                break;
            case NSFetchedResultsChangeUpdate:
                [collectionView reloadSections:[NSIndexSet indexSetWithIndex:self.sectionIndex]];
                break;
        }
    }
}

@end
