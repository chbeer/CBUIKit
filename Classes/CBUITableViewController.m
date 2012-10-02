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

- (id) initWithStyle:(UITableViewStyle)style {
    self = [super init];
	if (!self) return nil;
    
	_style = style;

	return self;
}

- (void) loadView {
    [super loadView];
    
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:_style];
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
        [self.view addSubview:_tableView];
    }    
}

- (void) dealloc {
    [_tableView release]; _tableView = nil;
    
    [super dealloc];
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
