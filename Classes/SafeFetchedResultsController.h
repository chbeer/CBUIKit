#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

//
// Taken from http://deusty.blogspot.com/2010/02/more-bugs-in-nsfetchedresultscontroller.html 
//  Created by Robbie Hanson on 2/15/10.
//
// Thanks Robbie for sharing!!
//

@protocol SafeFetchedResultsControllerDelegate;


@interface SafeFetchedResultsController : NSFetchedResultsController <NSFetchedResultsControllerDelegate>
{
	id <SafeFetchedResultsControllerDelegate> safeDelegate;
	
	NSMutableArray *insertedSections;
	NSMutableArray *deletedSections;
	
	NSMutableArray *insertedObjects;
	NSMutableArray *deletedObjects;
	NSMutableArray *updatedObjects;
	NSMutableArray *movedObjects;
}

@property (nonatomic, assign) id <SafeFetchedResultsControllerDelegate> safeDelegate;

@end

@protocol SafeFetchedResultsControllerDelegate <NSFetchedResultsControllerDelegate, NSObject>
@optional

- (void)controllerDidMakeUnsafeChanges:(NSFetchedResultsController *)controller;

@end