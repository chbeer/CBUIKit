//
//  CBUITableViewDataSource.h
//  VocabuTrainer
//
//  Created by Christian Beer on 20.03.10.
//  Copyright 2010 Christian Beer. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CBUITableViewDataSource;

@protocol CBUITableViewDataSourceDelegate

- (void) dataSourceDidFinishLoading:(CBUITableViewDataSource*)dataSource;
@optional
- (Class) tableView:(UITableView*)tableView cellClassForObject:(id)object atIndexPath:(NSIndexPath*)indexPath;
- (Class) tableView:(UITableView*)tableView cellClassForObject:(id)object;

@end


@protocol CBUITableViewDataSource <UITableViewDataSource>

- (id) objectAtIndexPath:(NSIndexPath*)indexPath;

@optional

- (Class) tableView:(UITableView*)tableView cellClassForObject:(id)object;

@end

@protocol CBUITableViewCell <NSObject>

- (void) setObject:(id)object;

@end




@interface CBUITableViewDataSource : NSObject <CBUITableViewDataSource,UITableViewDataSource> {
	UITableView *_tableView;
	
    id<CBUITableViewDataSourceDelegate> _delegate;
}

@property (nonatomic, retain) IBOutlet UITableView *tableView;

@property (nonatomic, assign) id<CBUITableViewDataSourceDelegate> delegate;

@property (nonatomic, retain) IBOutlet UITableViewCell<CBUITableViewCell> *tableViewCell;
@property (assign) Class defaultTableViewCellClass;

- (id) initWithTableView: (UITableView *) aTableView;

- (void) didFinishLoading;

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