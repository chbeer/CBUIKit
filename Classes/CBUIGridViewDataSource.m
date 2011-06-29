//
//  CBGridViewDataSource.m
//
//  Created by Christian Beer on 21.01.11.
//  Copyright 2011 Christian Beer. All rights reserved.
//

#import "CBUIGridViewDataSource.h"

@implementation CBUIGridViewDataSource

@synthesize defaultGridCellClass;

- (id) initWithGridView:(CBUIGridView*)aGridView {
    self  = [super init];
    if (!self) return nil;
    
    gridView = [aGridView retain];
    
    defaultGridCellClass = [CBGridViewCell class];
    
    return self;
}

- (void) dealloc {
    [gridView release]; gridView = nil;
    [super dealloc];
}

#pragma mark CBGridViewDataSource

- (NSUInteger) numberOfItemsInGridView: (CBUIGridView *) gridView {
    return 0;
}

- (UIView<CBGridViewCell>*)gridView:(CBUIGridView*)aGridView cellForItemAtIndex:(NSUInteger)index {
    id item = [self gridView:gridView objectAtIndex:index];
	
    Class class = [self gridView:aGridView cellClassForObject:item];
    NSString *identifier = NSStringFromClass(class);
    
    NSString *nibName = identifier;
    
    if ([aGridView.delegate respondsToSelector:@selector(nibNameForCellForObject:)]) {
        nibName = [aGridView.delegate performSelector:@selector(nibNameForCellForObject:) withObject:item];
    }
    
    UIView<CBGridViewCell> *newCell = nil;
    
    if ([[NSBundle mainBundle] pathForResource:nibName ofType:@"nib"]) {
        
        [[NSBundle mainBundle] loadNibNamed:identifier 
                                      owner:self 
                                    options:nil];
        
        newCell = gridViewCell;
//        newCell.reuseIdentifier = identifier;
//        newCell.selectionStyle = AQGridViewCellSelectionStyleBlue;
        
    } else {
        
        newCell = [[[class alloc] initWithFrame:CGRectZero 
                                reuseIdentifier:identifier] autorelease];
    }
    
    newCell.tag = index + TAG_PREFIX;
    
    if (newCell.tag == aGridView.selectedViewTag) {
        [newCell setSelected:YES animated:NO];
    }

	[newCell setObject:item];
	
	return newCell;
}

#pragma mark CBGridViewDataSource

- (Class) gridView:(CBUIGridView*)aGridView cellClassForObject:(id)object {
    if ([aGridView.delegate respondsToSelector:@selector(gridView:cellClassForObject:)]) {
        return [(id<CBGridViewDelegate>)aGridView.delegate gridView:aGridView cellClassForObject:object];
    }
	return defaultGridCellClass;
}

- (id) gridView:(CBUIGridView*)gridView objectAtIndex:(NSUInteger)index {
    return nil;
}

@end
