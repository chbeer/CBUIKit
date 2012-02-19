//
//  CBUITableViewDataSource.h
//  VocabuTrainer
//
//  Created by Christian Beer on 20.03.10.
//  Copyright 2010 Christian Beer. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CBUITableViewDataSource, CBUITableViewCell;

@protocol CBUITableViewCell;
@protocol CBUITableViewDataSourceDelegate;


@protocol CBUITableViewDataSource <UITableViewDataSource,NSObject>

- (id) objectAtIndexPath:(NSIndexPath*)indexPath;

@optional

- (Class) tableView:(UITableView*)tableView cellClassForObject:(id)object;

@end



@interface CBUITableViewDataSource : NSObject <CBUITableViewDataSource,UITableViewDataSource> {
	UITableView *_tableView;
	
    id<CBUITableViewDataSourceDelegate> _delegate;
}

@property (nonatomic, retain) IBOutlet UITableView *tableView;

@property (nonatomic, assign) id<CBUITableViewDataSourceDelegate> delegate;

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 50000  // available for iOS > 5.0
@property (nonatomic, copy) NSString *defaultTableViewCellReuseIdentifier; // can be used after IOS 5 for Automatic Cell Loading see WWDC '11 Session 125
#endif

@property (nonatomic, retain) IBOutlet UITableViewCell<CBUITableViewCell> *tableViewCell;
@property (assign) Class defaultTableViewCellClass;

@property (nonatomic, readonly, getter=isLoading)   BOOL            loading;
@property (nonatomic, readonly, getter=isEmpty)     BOOL            empty;


- (id) initWithTableView: (UITableView *) aTableView;

- (void) didFinishLoading;

- (NSArray*) selectedObjects;

@end


@interface CBUIArrayTableViewDataSource : CBUITableViewDataSource {
    NSMutableArray *_sections;
	NSMutableArray *_items;
}

@property (nonatomic, retain) NSMutableArray *sections;
@property (nonatomic, retain) NSMutableArray *items;

- (NSIndexPath*) indexPathForObject:(id)object;
- (void) removeObjectAtIndexPath:(NSIndexPath*)indexPath;

@end



//// ////

@protocol CBUITableViewCell <NSObject>

@optional

// Must implement at least one of those!
- (void) setObject:(id)object;
- (void) setObject:(id)object inTableView:(UITableView*)tableView;

@end


@protocol CBUITableViewDataSourceDelegate <NSObject>

@optional
- (void) dataSourceDidFinishLoading:(CBUITableViewDataSource*)dataSource;

- (Class) tableView:(UITableView*)tableView cellClassForObject:(id)object atIndexPath:(NSIndexPath*)indexPath;
- (Class) tableView:(UITableView*)tableView cellClassForObject:(id)object;

- (NSString*) tableView:(UITableView*)tableView reuseIdentifierForCellForObject:(id)object atIndexPath:(NSIndexPath*)indexPath;
- (NSString*) tableView:(UITableView*)tableView reuseIdentifierForCellForObject:(id)object;

- (void) dataSource:(CBUITableViewDataSource*)dataSource didCreateCell:(UITableViewCell<CBUITableViewCell>*)cell forTableView:(UITableView*)tableView atIndexPath:(NSIndexPath*)indexPath;

@end