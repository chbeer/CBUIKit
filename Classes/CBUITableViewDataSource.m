//
//  CBUITableViewDataSource.m
//  VocabuTrainer
//
//  Created by Christian Beer on 20.03.10.
//  Copyright 2010 Christian Beer. All rights reserved.
//

#import "CBUITableViewDataSource.h"

#import <objc/runtime.h>


@interface CBUITableViewDataSource ()

@property (nonatomic, assign) BOOL loading;
@property (nonatomic, assign) BOOL empty;

@end


@implementation CBUITableViewDataSource

@synthesize tableView = _tableView;
@synthesize delegate = _delegate;

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 50000  // available for iOS > 5.0
@synthesize defaultTableViewCellReuseIdentifier = _defaultTableViewCellReuseIdentifier;
#endif

@synthesize tableViewCell = _tableViewCell;
@synthesize defaultTableViewCellClass = _defaultTableViewCellClass;

@synthesize loading = _loading;
@synthesize empty   = _empty;

- (instancetype) initWithTableView:(UITableView *) aTableView  {
    if (self = [self init]) {
        [self setTableView: aTableView];
    }
    return self;
}

- (void) dealloc {
    _defaultTableViewCellReuseIdentifier = nil;
	
}

- (Class) tableView:(UITableView *)tableView cellClassForObject:(id)object {
    if ([tableView.delegate respondsToSelector:@selector(tableView:cellClassForObject:)]) {
        return [(id<CBUITableViewDataSourceDelegate>)tableView.delegate tableView:tableView cellClassForObject:object];
    }
	return nil;
}
- (Class) tableView:(UITableView *)tableView cellClassForObject:(id)object atIndexPath:(NSIndexPath*)indexPath {
    if ([tableView.delegate respondsToSelector:@selector(tableView:cellClassForObject:atIndexPath:)]) {
        return [(id<CBUITableViewDataSourceDelegate>)tableView.delegate tableView:tableView cellClassForObject:object atIndexPath:indexPath];
    }
	return nil;
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 50000  // available for iOS > 5.0
- (NSString*) tableView:(UITableView *)tableView reuseIdentifierForCellForObject:(id)object {
    if ([tableView.delegate respondsToSelector:@selector(tableView:reuseIdentifierForCellForObject:)]) {
        return [(id<CBUITableViewDataSourceDelegate>)tableView.delegate tableView:tableView reuseIdentifierForCellForObject:object];
    }
	return nil;
}
- (NSString*) tableView:(UITableView *)tableView reuseIdentifierForCellForObject:(id)object atIndexPath:(NSIndexPath*)indexPath {
    if ([tableView.delegate respondsToSelector:@selector(tableView:reuseIdentifierForCellForObject:atIndexPath:)]) {
        return [(id<CBUITableViewDataSourceDelegate>)tableView.delegate tableView:tableView reuseIdentifierForCellForObject:object atIndexPath:indexPath];
    }
	return nil;
}
#endif

- (id) objectAtIndexPath:(NSIndexPath*)indexPath {
	return nil;
}


#pragma mark UITableViewDataSource 

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger) tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section {
	return 0;
}

- (UITableViewCell*) tableView:(UITableView *)tableView 
		 cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	id item = [self objectAtIndexPath:indexPath];

    Class class = nil;
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 50000  // available for iOS > 5.0
    NSString *identifier = [self tableView:tableView reuseIdentifierForCellForObject:item atIndexPath:indexPath];
    if (!identifier) {
        identifier = [self tableView:tableView reuseIdentifierForCellForObject:item];
    }
    if (!identifier) {
        identifier = self.defaultTableViewCellReuseIdentifier;
    }
    
    if (!identifier) {
#endif
	
    class = [self tableView:tableView cellClassForObject:item atIndexPath:indexPath];
    if (!class) {
        class = [self tableView:tableView cellClassForObject:item];
    }    
    if (!class) {
        class = _defaultTableViewCellClass;
    }
    
    if (class) {
        identifier = NSStringFromClass(class);
    }
        
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 50000  // available for iOS > 5.0
    }
#endif
    
    UITableViewCell<CBUITableViewCell> *newCell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!newCell) {
        NSString *nibName = identifier;
        
        if ([class respondsToSelector:@selector(nibNameForCell)]) {
            nibName = [class performSelector:@selector(nibNameForCell)];
        }
        
        if ([[NSBundle mainBundle] pathForResource:nibName ofType:@"nib"]) {

            [[NSBundle mainBundle] loadNibNamed:identifier 
                                          owner:self 
                                        options:nil];
            
            newCell = _tableViewCell;
            
        } else {
        
            newCell = [[class alloc] initWithStyle:self.defaultTableViewCellStyle
                                    reuseIdentifier:identifier];
            
        }
    }
        
    if ([newCell respondsToSelector:@selector(setObject:inTableView:)]) {
        [newCell setObject:item inTableView:tableView];
    } else if ([newCell respondsToSelector:@selector(setObject:)]) {
        [newCell setObject:item];
    }
    
    if ([_delegate respondsToSelector:@selector(dataSource:didCreateCell:forTableView:atIndexPath:)]) {
        [_delegate dataSource:self didCreateCell:newCell forTableView:tableView atIndexPath:indexPath];
    }
	
	return newCell;
}

- (void) didFinishLoading {
    if ([_delegate respondsToSelector:@selector(dataSourceDidFinishLoading:)]) {
        [_delegate dataSourceDidFinishLoading:self];
    }
}

#pragma mark - Helper

- (NSArray*) selectedObjects
{
    NSMutableArray *items = [NSMutableArray array];
    [[self.tableView indexPathsForSelectedRows] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [items addObject:[self objectAtIndexPath:obj]];
    }];
    return items;
}

@end


@implementation CBUIArrayTableViewDataSource

@synthesize sections = _sections;
@synthesize items = _items;

@synthesize editable = _editable;

- (instancetype)initWithTableView:(UITableView *)aTableView
{
    self = [super initWithTableView:aTableView];
    if (!self) return nil;
    
    _items = [[NSMutableArray alloc] init];
    self.editable = YES;
    
    return self;
}

- (instancetype)initWithTableView:(UITableView *)aTableView items:(NSArray*)items
{
    self = [super initWithTableView:aTableView];
    if (!self) return nil;
    
    _items = [items mutableCopy];
    self.empty = self.items.count == 0;
    
    self.editable = YES;

    return self;
}

- (void) dealloc {
    _tableView = nil;
    _sections = nil;
    _items = nil;
	
}

#pragma mark Accessors

- (void)setItems:(NSArray *)items
{
    if (_items != items) {
        _items = [items mutableCopy];
        
        self.empty = self.items.count == 0;
        [self.tableView reloadData];
    }
}
- (void) addItemsObject:(id)object inSectionAtIndex:(NSUInteger)sectionIndex
{
    NSIndexPath *path = nil;
    if (_sections) {
        NSMutableArray *section = _items[sectionIndex];
        [section addObject:object];
        path = [NSIndexPath indexPathForRow:section.count - 1 
                                  inSection:sectionIndex];
    } else {
        [_items addObject:object];
        path = [NSIndexPath indexPathForRow:_items.count - 1 
                                  inSection:0];
    }
    
    if (path) {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 50000
        UITableViewRowAnimation anim = UITableViewRowAnimationAutomatic;
#else
        UITableViewRowAnimation anim = UITableViewRowAnimationFade;
#endif
        [_tableView insertRowsAtIndexPaths:@[path] 
                          withRowAnimation:anim];
    }
     
    self.empty = NO;
}
- (void) removeItemsObject:(id)object inSectionAtIndex:(NSUInteger)sectionIndex
{
    NSIndexPath *path = nil;
    if (_sections) {
        NSMutableArray *section = _items[sectionIndex];
        NSUInteger rowIndex = [section indexOfObject:object];
        if (rowIndex == NSNotFound) return;
        
        [section removeObject:object];
        path = [NSIndexPath indexPathForRow:rowIndex inSection:sectionIndex];
    } else {
        NSUInteger rowIndex = [_items indexOfObject:object];
        if (rowIndex == NSNotFound) return;

        [_items removeObject:object];
        path = [NSIndexPath indexPathForRow:rowIndex 
                                  inSection:0];
    }
    
    if (path) {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 50000
        UITableViewRowAnimation anim = UITableViewRowAnimationAutomatic;
#else
        UITableViewRowAnimation anim = UITableViewRowAnimationFade;
#endif
        [_tableView deleteRowsAtIndexPaths:@[path] 
                          withRowAnimation:anim];
    }
    
    self.empty = self.items.count == 0;
}

#pragma mark CBUITableViewDataSource

- (id) objectAtIndexPath:(NSIndexPath*)indexPath {
	if (_sections) {
		return _items[indexPath.section][indexPath.row];
	} else {
        if (indexPath.row >= _items.count) return nil;
		return _items[indexPath.row];
	}
}
- (NSIndexPath*) indexPathForObject:(id)object {
	if (_sections) {
		int sidx = 0;
		for (NSArray *a in _items) {
			NSUInteger idx = [a indexOfObject:object];
			if (idx != NSNotFound) {
				return [NSIndexPath indexPathForRow:idx inSection:sidx];
			}
			sidx++;
		}
	} else {
		NSUInteger idx = [_items indexOfObject:object];
		if (idx != NSNotFound) {
			return [NSIndexPath indexPathForRow:idx inSection:0];
		}
	}
	return nil;
}
- (void) removeObjectAtIndexPath:(NSIndexPath*)indexPath {
	if (_sections) {
		NSMutableArray *s = _items[indexPath.section];
		[s removeObjectAtIndex:indexPath.row];
		if (s.count == 0) {
			[_items removeObjectAtIndex:indexPath.section];
			[_sections removeObjectAtIndex:indexPath.section];
			[_tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section]
					  withRowAnimation:UITableViewRowAnimationFade];
		} else {
			[_tableView deleteRowsAtIndexPaths:@[indexPath]
							  withRowAnimation:UITableViewRowAnimationFade];
		}
	} else {
		[_items removeObjectAtIndex:indexPath.row];
		[_tableView deleteRowsAtIndexPaths:@[indexPath]
						  withRowAnimation:UITableViewRowAnimationFade];
	}
    
    self.empty = self.items.count == 0;
}

#pragma mark UITableViewDataSource

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
	return _sections ? [_sections count] : 1;
}

- (NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return _sections ? _sections[section] : nil;
}

- (NSInteger) tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section {
	if (_sections) {
		return [_items[section] count];
	} else {
		return _items.count;
	}
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.editable;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView.delegate respondsToSelector:@selector(tableView:commitEditingStyle:forRowAtIndexPath:)]) {
        [(id)tableView.delegate tableView:tableView commitEditingStyle:editingStyle forRowAtIndexPath:indexPath];
    }
}

@end