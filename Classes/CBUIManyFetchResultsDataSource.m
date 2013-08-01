//
//  CBUIManyFetchResultsDataSource.m
//  CBUIKit
//
//  Created by Christian Beer on 10.07.12.
//  Copyright (c) 2012 Christian Beer. All rights reserved.
//

#import "CBUIManyFetchResultsDataSource.h"

@interface CBUITableViewDataSource ()

@property (nonatomic, assign) BOOL loading;
@property (nonatomic, assign) BOOL empty;

@property (nonatomic, retain) NSArray *preservedSelection;

@end

#define StringFromIndexPath(indexPath) [NSString stringWithFormat:@"[%lu, %lu]", indexPath.section, indexPath.row]

@implementation CBUIManyFetchResultsDataSource {
    NSMutableArray *_sections;
}

@synthesize sections                    = _sections;
@synthesize ignoreForUpdateIndexPath    = _ignoreForUpdateIndexPath;

@synthesize preserveSelectionOnUpdate   = _preserveSelectionOnUpdate;
@synthesize preservedSelection          = _preservedSelection;

@synthesize allowsDeletion              = _allowsDeletion;

- (id) initWithTableView:(UITableView*)tableView
{
	self = [super initWithTableView:tableView];
    if (!self) return nil;
    
    _preserveSelectionOnUpdate = NO;
    _allowsDeletion = YES;
    
    _sections = [[NSMutableArray alloc] init];
    
    self.loading = NO;
    self.empty = YES;
    
	return self;
}

- (void) dealloc {
    [_sections enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        CBUIManyFetchResultsSection *section = obj;
        section.fetchedResultsController.delegate = nil;
        section.fetchedResultsController = nil;
    }];
    _ignoreForUpdateIndexPath = nil;
    
}

- (BOOL) performFetch:(NSError**)error
{
    self.loading = YES;
    
    __block BOOL result = YES;
    __block BOOL empty = YES;
    [_sections enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        CBUIManyFetchResultsSection *section = obj;
        if (![section.fetchedResultsController performFetch:error]) {
            result = NO;
            return;
        }
        if (section.fetchedResultsController.fetchedObjects.count != 0) {
            empty = NO;
        }
    }];
    
    self.loading = NO;
    [self.tableView reloadData];
    
    self.empty = empty;
    
    return result;
}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return self.empty ? 0 : self.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIdx {
    CBUIManyFetchResultsSection *section = [self.sections objectAtIndex:sectionIdx];
	id <NSFetchedResultsSectionInfo> sectionInfo = [[section.fetchedResultsController sections] objectAtIndex:0];
    return [sectionInfo numberOfObjects];
}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)sectionIdx {
    CBUIManyFetchResultsSection *section = [self.sections objectAtIndex:sectionIdx];
    return [section title];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    id object = [self objectAtIndexPath:indexPath];
    
    if (editingStyle == UITableViewCellEditingStyleDelete && self.allowsDeletion && [object isKindOfClass:[NSManagedObject class]]) {
        NSManagedObject *managedObject = (NSManagedObject*)object;
        
        [managedObject.managedObjectContext deleteObject:managedObject];
    }
}

#pragma mark NSFetchedResultsControllerDelegate

- (NSInteger) indexOfFetchedResultsController:(NSFetchedResultsController *)controller
{
    __block NSInteger result = NSNotFound;
    [_sections enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        CBUIManyFetchResultsSection *section = obj;
        if (section.fetchedResultsController == controller) {
            result = idx;
            *stop = YES;
        }
    }];
    return result;
}

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
	
    NSInteger section = [self indexOfFetchedResultsController:controller];
    indexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:section];
    newIndexPath = [NSIndexPath indexPathForRow:newIndexPath.row inSection:section];
    
    if ([_ignoreForUpdateIndexPath isEqual:indexPath]) return;
    
    switch(type)
	{
		case NSFetchedResultsChangeInsert:
		{
						
			[self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                                  withRowAnimation:UITableViewRowAnimationFade];
			break;
		}
		case NSFetchedResultsChangeDelete:
		{
						
			[self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                                  withRowAnimation:UITableViewRowAnimationFade];
			break;
		}
		case NSFetchedResultsChangeUpdate:
		{
			if (newIndexPath == nil || [newIndexPath isEqual:indexPath])
			{
								
				[self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                                      withRowAnimation:UITableViewRowAnimationNone];
			}
			else
			{
								
                [self.tableView moveRowAtIndexPath:indexPath
                                       toIndexPath:newIndexPath];
			}
			
			break;
		}
		case NSFetchedResultsChangeMove:
		{
						
			[self.tableView moveRowAtIndexPath:indexPath
                                   toIndexPath:newIndexPath];
			
			break;
		}
	}
}

- (void)controller:(NSFetchedResultsController *)controller
  didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex
     forChangeType:(NSFetchedResultsChangeType)type
{
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
		
    __block BOOL empty = YES;
    [_sections enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        CBUIManyFetchResultsSection *section = obj;
        if (section.fetchedResultsController.fetchedObjects.count != 0) {
            empty = NO;
            *stop = YES;
        }
    }];
    self.empty = empty;
    
	[self.tableView endUpdates];
    
    if (self.preserveSelectionOnUpdate && self.preservedSelection) {
        [self.preservedSelection enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [self.tableView selectRowAtIndexPath:obj animated:NO scrollPosition:UITableViewScrollPositionNone];
        }];
    }
}

#pragma mark CBUITableViewDataSource

- (id) objectAtIndexPath:(NSIndexPath*)indexPath {
    CBUIManyFetchResultsSection *section = [self.sections objectAtIndex:indexPath.section];
	return [section objectAtRow:indexPath.row];
}


#pragma mark -

- (void) addSectionWithTitle:(NSString *)title fetchRequest:(NSFetchRequest *)fetchRequest managedObjectContext:(NSManagedObjectContext *)context
{
    CBUIManyFetchResultsSection *section = [[CBUIManyFetchResultsSection alloc] init];
    section.title = title;
    
    section.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                           managedObjectContext:context
                                                                             sectionNameKeyPath:nil
                                                                                      cacheName:nil];
    section.fetchedResultsController.delegate = self;
    [_sections addObject:section];
}

@end


@implementation CBUIManyFetchResultsSection

@synthesize title = _title;
@synthesize fetchedResultsController = _fetchedResultsController;

- (id) objectAtRow:(NSUInteger)row
{
    NSManagedObject *managedObject = [self.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
	return managedObject;
}

@end