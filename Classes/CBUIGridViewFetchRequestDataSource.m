//
//  CBGridViewFetchRequestDataSource.m
//
//  Created by Christian Beer on 21.01.11.
//  Copyright 2011 Christian Beer. All rights reserved.
//

#import "CBUIGridViewFetchRequestDataSource.h"

@implementation CBUIGridViewFetchRequestDataSource

@synthesize fetchedResultsController = _fetchedResultsController;

- (id) initWithGridView:(CBUIGridView*)aGridView
           fetchRequest:(NSFetchRequest*)fetchRequest managedObjectContext:(NSManagedObjectContext*)context 
              cacheName:(NSString*)cacheName {
	self = [super initWithGridView:aGridView];
    if (!self) return nil;
    
    _fetchedResultsController = [[NSFetchedResultsController alloc]
                                 initWithFetchRequest:fetchRequest
                                 managedObjectContext:context
                                 sectionNameKeyPath:nil
                                 cacheName:cacheName];
    _fetchedResultsController.delegate = self;
    
    NSError *error;
    if (![_fetchedResultsController performFetch:&error]) {
        NSLog(@"!! fetchedResultsControlloer performFetch failed: %@", error);
        return nil;
    }
    
	return self;
}

+ (CBUIGridViewFetchRequestDataSource*) dataSourceWithGridView:(CBUIGridView*)gridView
                                          fetchRequest:(NSFetchRequest*)fetchRequest 
                                          managedObjectContext:(NSManagedObjectContext*)context
                                                     cacheName:(NSString*)cacheName {
	CBUIGridViewFetchRequestDataSource *ds = [[[self class] alloc] initWithGridView:gridView
                                                                       fetchRequest:fetchRequest
                                                               managedObjectContext:context
                                                                          cacheName:cacheName];
	
	return [ds autorelease];
    
}

- (void) dealloc {
    [_fetchedResultsController dealloc], _fetchedResultsController = nil;
    
    [super dealloc];
}

#pragma mark CBGridViewDataSource

- (NSUInteger) numberOfItemsInGridView: (CBUIGridView *) gridView {
    NSArray *sections = [_fetchedResultsController sections];
	if (sections.count > 0) {
		id <NSFetchedResultsSectionInfo> sectionInfo = [sections objectAtIndex:0];
		return [sectionInfo numberOfObjects];
	} else {
		return 0;
	}
}

- (id) gridView:(CBUIGridView*)gridView objectAtIndex:(NSUInteger)index {
    NSManagedObject *managedObject = [_fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:index 
                                                                                                     inSection:0]];
	return managedObject;
}

#pragma mark NSFetchedResultsControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
//    [_tableView beginUpdates];
}


- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    
/*    switch(type) {
        case NSFetchedResultsChangeInsert:
            [_tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                      withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [_tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                      withRowAnimation:UITableViewRowAnimationFade];
            break;
    } */
}


- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
    
/*    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [_tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                              withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [_tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                              withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                              withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeMove:
            [_tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                              withRowAnimation:UITableViewRowAnimationFade];
            [_tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                              withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
 */
}


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {

    [gridView reloadData];
    
//    [_tableView endUpdates];
}


@end
