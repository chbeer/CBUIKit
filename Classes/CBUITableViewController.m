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
{
    BOOL _keyboardIsShown;
	UITableViewStyle _style;
}

@synthesize tableView = _tableView;

@synthesize clearsSelectionOnViewWillAppear = _clearsSelectionOnViewWillAppear;

- (instancetype) initWithStyle:(UITableViewStyle)style {
    self = [super init];
	if (!self) return nil;
    
	_style = style;

	return self;
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    
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


- (void) viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
    if (_clearsSelectionOnViewWillAppear) {
        NSIndexPath *indexPath = [_tableView indexPathForSelectedRow];
        if (indexPath) {
            [_tableView deselectRowAtIndexPath:indexPath animated:YES];
        }
    }
}

- (void) setEditing:(BOOL)editing animated:(BOOL)animated
{
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
    if (!CBIsIPad() && !_keyboardIsShown) {
        NSDictionary *userInfo = notif.userInfo;
        
        [UIView beginAnimations:@"keyboardWillShow" 
                        context:nil];
        
        [UIView setAnimationCurve:[userInfo[UIKeyboardAnimationCurveUserInfoKey] intValue]];
        [UIView setAnimationDuration:[userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue]];
        
        CGSize size = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
		
/*        CGRect frame = self.view.frame;
        
        if (!self.navigationController.toolbarHidden) {
            frame.size.height += self.navigationController.toolbar.bounds.size.height;
        }
        
        _tableView.frame = frame;*/
        
        UIEdgeInsets insets = _tableView.contentInset;
        insets.bottom += size.height;
        _tableView.contentInset = insets;
        
        [UIView commitAnimations];
        
        _keyboardIsShown = YES;
    }
}

- (void)keyboardWillHide:(NSNotification*)notif {
    if (!CBIsIPad() && _keyboardIsShown) {
        NSDictionary *userInfo = notif.userInfo;
        
        [UIView beginAnimations:@"keyboardWillHide"
                        context:nil];
        
        [UIView setAnimationCurve:[userInfo[UIKeyboardAnimationCurveUserInfoKey] intValue]];
        [UIView setAnimationDuration:[userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue]];
        
        CGSize size = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
        
        /*CGRect frame = self.view.frame;
        
        if (!self.navigationController.toolbarHidden) {
            frame.size.height -= self.navigationController.toolbar.bounds.size.height;
        }
        
        _tableView.frame = frame;*/
        
        UIEdgeInsets insets = _tableView.contentInset;
        insets.bottom -= size.height;
        _tableView.contentInset = insets;
        
        [UIView commitAnimations];
        
        _keyboardIsShown = NO;
    }
}

@end
