//
//  CBUITableViewController.m
//  CBUIKit
//
//  Created by Christian Beer on 08.03.11.
//  Copyright 2011 Christian Beer. All rights reserved.
//

#import "CBUITableViewController.h"

#import "CBUIGlobal.h"

@implementation CBUITableViewController

@synthesize tableView = _tableView;
@synthesize dataSource = _dataSource;

- (id) initWithStyle:(UITableViewStyle)style {
    self = [super init];
	if (!self) return nil;
    
	_style = style;

	return self;
}

- (void) loadView {
	UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
	
	_tableView = [[UITableView alloc] initWithFrame:view.bounds style:_style];
	_tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	_tableView.dataSource = self;
	_tableView.delegate = self;
    if (_tableView.style == UITableViewStylePlain) {
        _tableView.opaque = YES;
    } else {
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.opaque = NO;
    }
	_tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
	[view addSubview:_tableView];
    
	self.view = view;
	[view release];
}

- (void) dealloc {
    [_dataSource release], _dataSource = nil;
    [_tableView release]; _tableView = nil;
    
    [super dealloc];
}

- (void) viewDidLoad {
	[super viewDidLoad];
	
	_tableView.frame = self.view.bounds;
}

- (void) viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	NSIndexPath *ip = [_tableView indexPathForSelectedRow];
	if (ip) {
		[_tableView deselectRowAtIndexPath:ip animated:YES];
	}
}

- (void) setEditing:(BOOL)editing animated:(BOOL)animated {
	[super setEditing:editing animated:animated];
	[_tableView setEditing:editing animated:animated];
}

- (BOOL) isTableEmpty {
/*    if ([_dataSource respondsToSelector:@selector(isTableEmpty)]) {
        return [_dataSource isTableEmpty];
    }
  */  
    return ([_dataSource numberOfSectionsInTableView:_tableView] == 0);
}

#pragma mark UITableViewDataSource

- (NSInteger) tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section {
	return 0;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	return nil;
}

#pragma mark Keyboard movement

- (void)keyboardWillShow:(NSNotification*)notif {
    if (!CBIsIPad()) {
        [UIView beginAnimations:@"keyboardWillShow" 
                        context:nil];
        
        [UIView setAnimationCurve:[[notif.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue]];
        [UIView setAnimationDuration:[[notif.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue]];
        
        CGRect frame = self.view.frame;
        
        if (!self.navigationController.toolbarHidden) {
            frame.size.height += self.navigationController.toolbar.bounds.size.height;
        }
        
        _tableView.frame = frame;
        
        [UIView commitAnimations];
    }
}

- (void)keyboardWillHide:(NSNotification*)notif {
    if (!CBIsIPad()) {
        [UIView beginAnimations:@"keyboardWillHide" 
                        context:nil];
        
        [UIView setAnimationCurve:[[notif.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue]];
        [UIView setAnimationDuration:[[notif.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue]];
        
        CGRect frame = self.view.frame;
        
        if (!self.navigationController.toolbarHidden) {
            frame.size.height -= self.navigationController.toolbar.bounds.size.height;
        }
        
        _tableView.frame = frame;
        
        [UIView commitAnimations];
    }
}

@end
