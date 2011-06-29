//
//  CBGridViewFetchRequestDataSource.h
//
//  Created by Christian Beer on 21.01.11.
//  Copyright 2011 Christian Beer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

#import "CBUIGridView.h"

#import "CBUIGridViewDataSource.h"

@interface CBUIGridViewFetchRequestDataSource : CBUIGridViewDataSource <NSFetchedResultsControllerDelegate> {

    NSFetchedResultsController *_fetchedResultsController;
    
}

@property (readonly) NSFetchedResultsController *fetchedResultsController;

- (id) initWithGridView:(CBUIGridView*)gridView
           fetchRequest:(NSFetchRequest*)fetchRequest managedObjectContext:(NSManagedObjectContext*)context 
              cacheName:(NSString*)cacheName;

+ (CBUIGridViewFetchRequestDataSource*) dataSourceWithGridView:(CBUIGridView*)gridView fetchRequest:(NSFetchRequest*)fetchRequest 
                                          managedObjectContext:(NSManagedObjectContext*)context cacheName:(NSString*)cacheName;

@end
