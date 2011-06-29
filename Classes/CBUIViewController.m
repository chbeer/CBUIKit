//
//  CBUIViewController.m
//  CBUIKit
//
//  Created by Christian Beer on 08.03.11.
//  Copyright 2011 Christian Beer. All rights reserved.
//

#import "CBUIViewController.h"


@implementation CBUIViewController

- (void) viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
    
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardWillShow:)
												 name:UIKeyboardWillShowNotification 
											   object:nil];	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardWillHide:)
												 name:UIKeyboardWillHideNotification object:nil];	
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasHidden:)
                                                 name:UIKeyboardDidHideNotification object:nil];
}
- (void) viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
    
	[[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardDidShowNotification
                                                  object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardDidHideNotification
                                                  object:nil];
}

#pragma mark Keyboard movement

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWillShow:(NSNotification*)aNotification {
}
- (void)keyboardWasShown:(NSNotification*)aNotification {
}

- (void)keyboardWillHide:(NSNotification*)aNotification {
}
- (void)keyboardWasHidden:(NSNotification*)aNotification {
}

@end
