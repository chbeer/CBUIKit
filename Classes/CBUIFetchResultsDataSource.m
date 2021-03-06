//
//  CBUIFetchResultsDataSource.m
//  CBUIKit
//
//  Created by Christian Beer on 14.01.10.
//  Copyright 2010 Christian Beer. All rights reserved.
//
//
// Fixed some updating problems by integrating the changs, @mrrooni suggested here:
// http://www.fruitstandsoftware.com/blog/2013/02/uitableview-and-nsfetchedresultscontroller-updates-done-right/
//   -- Thanks, Michael!
//

#import "CBUIFetchResultsDataSource.h"

#import "CBUIGlobal.h"

//#define DEBUG

@interface CBUITableViewDataSource ()

@property (nonatomic, assign) BOOL loading;
@property (nonatomic, assign) BOOL empty;

@property (nonatomic, retain) NSArray *preservedSelection;

@end

@interface CBUIFetchResultsDataSource ()

// Declare some collection properties to hold the various updates we might get from the NSFetchedResultsControllerDelegate
@property (nonatomic, strong) NSMutableIndexSet *deletedSectionIndexes;
@property (nonatomic, strong) NSMutableIndexSet *insertedSectionIndexes;
@property (nonatomic, strong) NSMutableArray *deletedRowIndexPaths;
@property (nonatomic, strong) NSMutableArray *insertedRowIndexPaths;
@property (nonatomic, strong) NSMutableArray *updatedRowIndexPaths;

@end


#define StringFromIndexPath(indexPath) [NSString stringWithFormat:@"[%lu, %lu]", indexPath.section, indexPath.row]

@implementation CBUIFetchResultsDataSource

@synthesize fetchedResultsController = _fetchedResultsController;
@synthesize ignoreForUpdateIndexPath = _ignoreForUpdateIndexPath;

@synthesize preserveSelectionOnUpdate = _preserveSelectionOnUpdate;
@synthesize preservedSelection        = _preservedSelection;

@synthesize allowsDeletion            = _allowsDeletion;

- (instancetype) initWithTableView:(UITableView*)tableView
            fetchRequest:(NSFetchRequest*)fetchRequest managedObjectContext:(NSManagedObjectContext*)context 
      sectionNameKeyPath:(NSString*)sectionNameKeyPath
               cacheName:(NSString*)cacheName 
{
	self = [super initWithTableView:tableView];
    if (!self) return nil;
    
    _preserveSelectionOnUpdate = NO;
    _allowsDeletion = YES;
    
    if (CBUIMinimumVersion(4.0)) {
        _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                        managedObjectContext:context
                                                                          sectionNameKeyPath:sectionNameKeyPath
                                                                                   cacheName:cacheName];
        self.fetchedResultsController.delegate = self;    
    } else {
        _fetchedResultsController = [[SafeFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                          managedObjectContext:context
                                                                            sectionNameKeyPath:sectionNameKeyPath
                                                                                     cacheName:cacheName];
        [(SafeFetchedResultsController*)self.fetchedResultsController setSafeDelegate:self];
    }

    self.loading = NO;
    self.empty = YES;
    
    self.insertRowAnimation = UITableViewRowAnimationRight;
    self.deleteRowAnimation = UITableViewRowAnimationLeft;
    self.updateRowAnimation = UITableViewRowAnimationAutomatic;

    
	return self;
}
- (instancetype) initWithTableView:(UITableView*)tableView
            fetchRequest:(NSFetchRequest*)fetchRequest managedObjectContext:(NSManagedObjectContext*)context 
               cacheName:(NSString*)cacheName 
{
    return [self initWithTableView:tableView
                      fetchRequest:fetchRequest 
              managedObjectContext:context 
                sectionNameKeyPath:nil 
                         cacheName:cacheName];
}

+ (CBUIFetchResultsDataSource*) dataSourceWithTableView:(UITableView*)tableView
                                           fetchRequest:(NSFetchRequest*)fetchRequest managedObjectContext:(NSManagedObjectContext*)context
                                        sectionNameKeyPath:(NSString*)sectionNameKeyPath cacheName:(NSString*)cacheName {
	CBUIFetchResultsDataSource *ds = [[[self class] alloc] initWithTableView:tableView
                                                                fetchRequest:fetchRequest
                                                           managedObjectContext:context
                                                             sectionNameKeyPath:sectionNameKeyPath
                                                                      cacheName:cacheName];
	
	return ds;
    
}

+ (CBUIFetchResultsDataSource*) dataSourceWithTableView:(UITableView*)tableView fetchRequest:(NSFetchRequest*)fetchRequest 
                                   managedObjectContext:(NSManagedObjectContext*)context cacheName:(NSString*)cacheName {
    return [self dataSourceWithTableView:tableView fetchRequest:fetchRequest managedObjectContext:context 
                         sectionNameKeyPath:nil cacheName:cacheName];
}

- (void) dealloc {
    _fetchedResultsController.delegate = nil;
    _fetchedResultsController = nil;
    _ignoreForUpdateIndexPath = nil;
    
}

- (BOOL) performFetch:(NSError**)error
{
    self.loading = YES;
    BOOL result = [_fetchedResultsController performFetch:error];
    self.loading = NO;
    [self.tableView reloadData];
    
    self.empty = _fetchedResultsController.fetchedObjects.count == 0;
    
    return result;
}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return [[_fetchedResultsController sections] count];
}
- (id<NSFetchedResultsSectionInfo>) infoForSectionAtIndex:(NSInteger)section
{
    return [_fetchedResultsController sections][section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	id <NSFetchedResultsSectionInfo> sectionInfo = [_fetchedResultsController sections][section];
    return [sectionInfo numberOfObjects];
}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    id<NSFetchedResultsSectionInfo> sectionInfo = [_fetchedResultsController sections][section];
    return [sectionInfo name];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete && self.allowsDeletion) {
        BOOL delete = YES;
        if ([self.delegate respondsToSelector:@selector(dataSource:shouldDeleteObjectAtIndexPath:)]) {
            delete = [(id<CBUIFetchResultsDataSourceDelegate>)self.delegate dataSource:self shouldDeleteObjectAtIndexPath:indexPath];
        }
        
        if (delete) {
            id object = [self objectAtIndexPath:indexPath];
            if ([object isKindOfClass:[NSManagedObject class]]) {
                NSManagedObject *managedObject = (NSManagedObject*)object;
        
                [managedObject.managedObjectContext deleteObject:managedObject];
            }
        }
        
        if ([self.delegate respondsToSelector:@selector(dataSource:didDeleteObjectAtIndexPath:)]) {
            [(id<CBUIFetchResultsDataSourceDelegate>)self.delegate dataSource:self didDeleteObjectAtIndexPath:indexPath];
        }
    }
}

#pragma mark NSFetchedResultsControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    if (self.preserveSelectionOnUpdate) {
        self.preservedSelection = [self.tableView indexPathsForSelectedRows];
    }
    
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath
	 forChangeType:(NSFetchedResultsChangeType)type
	  newIndexPath:(NSIndexPath *)newIndexPath
{
	    
    if ([_ignoreForUpdateIndexPath isEqual:indexPath]) return;
	
    switch(type)
	{
		case NSFetchedResultsChangeInsert:
		{
						
			if (![self.insertedSectionIndexes containsIndex:newIndexPath.section]) {
                // If we've already been told that we're adding a section for this inserted row we skip it since it will handled by the section insertion.
                
                [self.insertedRowIndexPaths addObject:newIndexPath];
            }
            
			break;
		}
		case NSFetchedResultsChangeDelete:
		{
						
			if (![self.deletedSectionIndexes containsIndex:indexPath.section]) {
                // If we've already been told that we're deleting a section for this deleted row we skip it since it will handled by the section deletion.
                [self.deletedRowIndexPaths addObject:indexPath];
            }
            
			break;
		}
		case NSFetchedResultsChangeUpdate:
		{
                        
            [self.updatedRowIndexPaths addObject:indexPath];
            
			break;
		}
		case NSFetchedResultsChangeMove:
		{
						
			if (![self.insertedSectionIndexes containsIndex:newIndexPath.section]) {
                [self.insertedRowIndexPaths addObject:newIndexPath];
            }
            
            if (![self.deletedSectionIndexes containsIndex:indexPath.section]) {
                [self.deletedRowIndexPaths addObject:indexPath];
            }
			
			break;
		}
	}
}

- (void)controller:(NSFetchedResultsController *)controller
  didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex
     forChangeType:(NSFetchedResultsChangeType)type
{
		
	switch(type)
	{
		case NSFetchedResultsChangeInsert:
		{
			            
			[self.insertedSectionIndexes addIndex:sectionIndex];
			break;
		}
		case NSFetchedResultsChangeDelete:
		{
						
			[self.deletedSectionIndexes addIndex:sectionIndex];
			break;
		}
            
        case NSFetchedResultsChangeMove:
        case NSFetchedResultsChangeUpdate:
            // do nothing
            break;
	}
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
		
    self.empty = _fetchedResultsController.fetchedObjects.count == 0;
    
    [self.tableView deleteSections:self.deletedSectionIndexes withRowAnimation:self.deleteRowAnimation];
    [self.tableView insertSections:self.insertedSectionIndexes withRowAnimation:self.insertRowAnimation];
    
    [self.tableView deleteRowsAtIndexPaths:self.deletedRowIndexPaths withRowAnimation:self.deleteRowAnimation];
    [self.tableView insertRowsAtIndexPaths:self.insertedRowIndexPaths withRowAnimation:self.insertRowAnimation];
    [self.tableView reloadRowsAtIndexPaths:self.updatedRowIndexPaths withRowAnimation:self.updateRowAnimation];
    
    [self.tableView endUpdates];

    
    if ([self.delegate respondsToSelector:@selector(fetchResultsDataSourceDidUpdateContent:)]) {
        [(id<CBUIFetchResultsDataSourceDelegate>)self.delegate fetchResultsDataSourceDidUpdateContent:self];
    }
    
    // nil out the collections so they are ready for their next use.
    self.insertedSectionIndexes = nil;
    self.deletedSectionIndexes = nil;
    self.deletedRowIndexPaths = nil;
    self.insertedRowIndexPaths = nil;
    self.updatedRowIndexPaths = nil;

    if (self.preserveSelectionOnUpdate && self.preservedSelection) {
        [self.preservedSelection enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [self.tableView selectRowAtIndexPath:obj animated:NO scrollPosition:UITableViewScrollPositionNone];
        }];
    }
}

- (void)controllerDidMakeUnsafeChanges:(NSFetchedResultsController *)controller
{
	    
    self.empty = _fetchedResultsController.fetchedObjects.count == 0;
	
	[self.tableView reloadData];
    
    if (self.preserveSelectionOnUpdate && self.preservedSelection) {
        [self.preservedSelection enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [self.tableView selectRowAtIndexPath:obj animated:NO scrollPosition:UITableViewScrollPositionNone];
        }];
    }
}

#pragma mark CBUITableViewDataSource

- (id) objectAtIndexPath:(NSIndexPath*)indexPath {
    NSManagedObject *managedObject = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
#ifndef CBUI_NoPrefaultNSManagedObject
    // un-fault object eventually. Returns nil if not able to unfault... prevents crashes
    // like: https://rink.hockeyapp.net/manage/apps/18828/app_versions/9/crash_reasons/18413870
    NSError *error;
    managedObject = [managedObject.managedObjectContext existingObjectWithID:managedObject.objectID
                                                                       error:&error];
#endif

	return managedObject;
}

#pragma mark -

- (NSIndexPath*) indexPathForObject:(id)object
{
    return [self.fetchedResultsController indexPathForObject:object];
}

#pragma mark -

// ONLY WORKS WITH ONE SECTION!!
- (BOOL) performFetchAndUpdateTableView:(NSError *__autoreleasing*)error
{
    NSArray *objectsBefore = self.fetchedResultsController.fetchedObjects;
    
    self.loading = YES;
    
    BOOL result = [self.fetchedResultsController performFetch:error];
    if (result) {
        
        NSArray *objectsAfter = self.fetchedResultsController.fetchedObjects;
        
        NSMutableArray *insertedObjects = [objectsAfter mutableCopy];
        [insertedObjects removeObjectsInArray:objectsBefore];
        
        NSMutableArray *removedObjects = [objectsBefore mutableCopy];
        [removedObjects removeObjectsInArray:objectsAfter];
        
        NSMutableArray *insertedIndexPaths = [NSMutableArray arrayWithCapacity:insertedObjects.count];
        [insertedObjects enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [insertedIndexPaths addObject:[NSIndexPath indexPathForRow:[objectsAfter indexOfObject:obj] inSection:0]];
        }];
        
        NSMutableArray *removedIndexPaths = [NSMutableArray arrayWithCapacity:removedObjects.count];
        [removedObjects enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [removedIndexPaths addObject:[NSIndexPath indexPathForRow:[objectsBefore indexOfObject:obj] inSection:0]];
        }];
        
        if (insertedIndexPaths.count > 0 || removedIndexPaths.count > 0) {
            [_tableView beginUpdates];
            
            [_tableView insertRowsAtIndexPaths:insertedIndexPaths 
                              withRowAnimation:UITableViewRowAnimationFade];
            [_tableView deleteRowsAtIndexPaths:removedIndexPaths 
                              withRowAnimation:UITableViewRowAnimationFade];
            
            [_tableView endUpdates];
        }
    }
    
    self.loading = NO;
    
    return result;
}

#pragma mark - 

/**
 * Lazily instantiate these collections.
 */

- (NSMutableIndexSet *)deletedSectionIndexes
{
    if (_deletedSectionIndexes == nil) {
        _deletedSectionIndexes = [[NSMutableIndexSet alloc] init];
    }
    
    return _deletedSectionIndexes;
}

- (NSMutableIndexSet *)insertedSectionIndexes
{
    if (_insertedSectionIndexes == nil) {
        _insertedSectionIndexes = [[NSMutableIndexSet alloc] init];
    }
    
    return _insertedSectionIndexes;
}

- (NSMutableArray *)deletedRowIndexPaths
{
    if (_deletedRowIndexPaths == nil) {
        _deletedRowIndexPaths = [[NSMutableArray alloc] init];
    }
    
    return _deletedRowIndexPaths;
}

- (NSMutableArray *)insertedRowIndexPaths
{
    if (_insertedRowIndexPaths == nil) {
        _insertedRowIndexPaths = [[NSMutableArray alloc] init];
    }
    
    return _insertedRowIndexPaths;
}

- (NSMutableArray *)updatedRowIndexPaths
{
    if (_updatedRowIndexPaths == nil) {
        _updatedRowIndexPaths = [[NSMutableArray alloc] init];
    }
    
    return _updatedRowIndexPaths;
}

- (NSDictionary*) updatesDictionary;
{
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    if (self.deletedSectionIndexes.count > 0) {
        result[@"DeletedSections"] = self.deletedSectionIndexes;
    }
    if (self.insertedSectionIndexes.count > 0) {
        result[@"InsertedSections"] = self.insertedSectionIndexes;
    }
    if (self.deletedRowIndexPaths.count > 0) {
        result[@"DeletedRows"] = self.deletedRowIndexPaths;
    }
    if (self.insertedRowIndexPaths.count > 0) {
        result[@"InsertedRows"] = self.insertedRowIndexPaths;
    }
    if (self.updatedRowIndexPaths.count > 0) {
        result[@"UpdatedRows"] = self.updatedRowIndexPaths;
    }
    return result;
}

@end



@implementation CBUIFetchResultsByKeyPathDataSource 

@synthesize objectKeyPath;

- (void) dealloc {
    objectKeyPath = nil;
}

#pragma mark CBUITableViewDataSource

- (id) objectAtIndexPath:(NSIndexPath*)indexPath {
    NSManagedObject *managedObject = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    
#ifndef CBUI_NoPrefaultNSManagedObject
    // un-fault object eventually. Returns nil if not able to unfault... prevents crashes
    // like: https://rink.hockeyapp.net/manage/apps/18828/app_versions/9/crash_reasons/18413870
    NSError *error;
    managedObject = [managedObject.managedObjectContext existingObjectWithID:managedObject.objectID
                                                                       error:&error];
#endif
    
    if (!objectKeyPath) return managedObject;
    
	return [managedObject valueForKeyPath:objectKeyPath];
}

@end