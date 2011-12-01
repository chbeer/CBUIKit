//
//  CBUIFetchResultsReorderDataSource.m
//  CBUIKit
//
//  Created by Christian Beer on 01.12.11.
//  Copyright (c) 2011 Christian Beer. All rights reserved.
//

#import "CBUIFetchResultsReorderDataSource.h"

@implementation CBUIFetchResultsReorderDataSource

- (id) initWithTableView:(UITableView*)tableView
            fetchRequest:(NSFetchRequest*)fetchRequest managedObjectContext:(NSManagedObjectContext*)context 
      sectionNameKeyPath:(NSString*)sectionNameKeyPath
               cacheName:(NSString*)cacheName 
{
    NSAssert([fetchRequest sortDescriptors].count == 1, @"CBUIFetchResultsReorderingDataSource can only be used with one sort descriptor!");
    NSAssert(sectionNameKeyPath == nil, @"CBUIFetchResultsReorderingDataSource must not be used with sectionNameKeyPath!");
    NSAssert(cacheName == nil, @"CBUIFetchResultsReorderingDataSource must not be used with cache name!");
    
    return [super initWithTableView:tableView fetchRequest:fetchRequest 
               managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    NSMutableArray *items = [self.fetchedResultsController.fetchedObjects mutableCopy];
    id object = [[items objectAtIndex:fromIndexPath.row] retain];
    [items removeObjectAtIndex:fromIndexPath.row];
    [items insertObject:object atIndex:toIndexPath.row];
    [object release];
    
    NSString *key = [[self.fetchedResultsController.fetchRequest.sortDescriptors objectAtIndex:0] key];
    
    int number = 1;
    for (id item in items) {
        NSNumber *oldNo = [item valueForKey:key];
        if ([oldNo intValue] != number) {
            [item setValue:[NSNumber numberWithInt:number] forKey:key];
        }
        
        number++;
    }
    
    [items release];
    
    NSError *error = nil;
    if (![self.fetchedResultsController performFetch:&error]) {
        NSLog(@"!! could not fetch results after move!");
    }
}

@end
