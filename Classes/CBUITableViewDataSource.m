//
//  CBUITableViewDataSource.m
//  VocabuTrainer
//
//  Created by Christian Beer on 20.03.10.
//  Copyright 2010 Christian Beer. All rights reserved.
//

#import "CBUITableViewDataSource.h"

#import <objc/runtime.h>

@implementation CBUITableViewDataSource

@synthesize tableView = _tableView;
@synthesize delegate = _delegate;
@synthesize defaultTableViewCellClass;

- (id) initWithTableView:(UITableView *) aTableView  {
    if (self = [self init]) {
        [self setTableView: aTableView];
        
        defaultTableViewCellClass = [UITableViewCell class];
        
    }
    return self;
}

- (void) dealloc {
    [_tableView release], _tableView = nil;
	
    [super dealloc];
}

- (Class) tableView:(UITableView *)tableView cellClassForObject:(id)object {
    if ([tableView.delegate respondsToSelector:@selector(tableView:cellClassForObject:)]) {
        return [(id<CBUITableViewDataSourceDelegate>)tableView.delegate tableView:tableView cellClassForObject:object];
    }
	return defaultTableViewCellClass;
}

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
	
    Class class = [self tableView:tableView cellClassForObject:item];
    NSString *identifier = NSStringFromClass(class);
    
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
            
            newCell = tableViewCell;
            
        } else {
        
            newCell = [[[class alloc] initWithStyle:UITableViewCellStyleDefault 
                                    reuseIdentifier:identifier] autorelease];
            
        }
    }
        
	[newCell setObject:item];
	
	return newCell;
}

- (void) didFinishLoading {
    [_delegate dataSourceDidFinishLoading:self];
}

@end


@implementation CBUIArrayTableViewDataSource

@synthesize sections = _sections;
@synthesize items = _items;

- (id)initWithTableView:(UITableView *)aTableView
{
    self = [super initWithTableView:aTableView];
    if (!self) return nil;
    
    _items = [[NSMutableArray alloc] init];
    
    return self;
}

- (void) dealloc {
    [_tableView release], _tableView = nil;
    [_sections release], _sections = nil;
    [_items release], _items = nil;
	
    [super dealloc];
}

#pragma mark Accessors

- (void) addItemsObject:(id)object inSectionAtIndex:(NSUInteger)sectionIndex
{
    NSIndexPath *path = nil;
    if (_sections) {
        NSMutableArray *section = [_items objectAtIndex:sectionIndex];
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
        [_tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:path] 
                          withRowAnimation:anim];
    }
        
}
- (void) removeItemsObject:(id)object inSectionAtIndex:(NSUInteger)sectionIndex
{
    NSIndexPath *path = nil;
    if (_sections) {
        NSMutableArray *section = [_items objectAtIndex:sectionIndex];
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
        [_tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:path] 
                          withRowAnimation:anim];
    }
}

#pragma mark CBUITableViewDataSource

- (id) objectAtIndexPath:(NSIndexPath*)indexPath {
	if (_sections) {
		return [[_items objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
	} else {
		return [_items objectAtIndex:indexPath.row];
	}
}
- (NSIndexPath*) indexPathForObject:(id)object {
	if (_sections) {
		int sidx = 0;
		for (NSArray *a in _items) {
			int idx = [a indexOfObject:object];
			if (idx != NSNotFound) {
				return [NSIndexPath indexPathForRow:idx inSection:sidx];
			}
			sidx++;
		}
	} else {
		int idx = [_items indexOfObject:object];
		if (idx != NSNotFound) {
			return [NSIndexPath indexPathForRow:idx inSection:0];
		}
	}
	return nil;
}
- (void) removeObjectAtIndexPath:(NSIndexPath*)indexPath {
	if (_sections) {
		NSMutableArray *s = [_items objectAtIndex:indexPath.section];
		[s removeObjectAtIndex:indexPath.row];
		if (s.count == 0) {
			[_items removeObjectAtIndex:indexPath.section];
			[_sections removeObjectAtIndex:indexPath.section];
			[_tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section]
					  withRowAnimation:UITableViewRowAnimationFade];
		} else {
			[_tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
							  withRowAnimation:UITableViewRowAnimationFade];
		}
	} else {
		[_items removeObjectAtIndex:indexPath.row];
		[_tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
						  withRowAnimation:UITableViewRowAnimationFade];
	}
}

#pragma mark UITableViewDataSource

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
	return _sections ? [_sections count] : 1;
}

- (NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return _sections ? [_sections objectAtIndex:section] : nil;
}

- (NSInteger) tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section {
	if (_sections) {
		return [[_items objectAtIndex:section] count];
	} else {
		return _items.count;
	}
}

@end