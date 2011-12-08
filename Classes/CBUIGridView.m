//
//  CBGridView.m
//
//  Created by Christian Beer on 21.01.11.
//  Copyright 2011 Christian Beer. All rights reserved.
//

#import "CBUIGridView.h"

#import "CBUIGridViewDataSource.h"

@implementation CBUIGridView

@synthesize dataSource, delegate;
@synthesize spacing, selectedViewTag;

#pragma mark -

- (void) dealloc {
    [super dealloc];
}


#pragma mark -

- (BOOL) isVertical {
    return self.bounds.size.width < self.bounds.size.height;
}

- (void) setDataSource:(id<CBUIGridViewDataSource>)aDataSource {
    dataSource = aDataSource;
}
    
- (void) reloadData {
    [scrollView release];
    
    scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    scrollView.pagingEnabled = NO;
    scrollView.delegate = self;
    scrollView.clipsToBounds = NO;
    scrollView.alwaysBounceVertical = [self isVertical];
    scrollView.alwaysBounceHorizontal = ![self isVertical];
    [self addSubview:scrollView];
    [scrollView release];
        
    int numberOfCells = [dataSource numberOfItemsInGridView:self];
    
    
    CGFloat coordinate = spacing;
    CGFloat cellSize;
        
    for (int index = 0; index < numberOfCells; index++) {
        
        id object = [dataSource gridView:self 
                           objectAtIndex:index];
        
        CGRect cellFrame;
        if ([self isVertical]) {
            cellSize = [delegate gridView:self heightForCellWithObject:object];
            cellFrame = CGRectMake(0.0, coordinate, self.bounds.size.width, cellSize);
        } else {
            cellSize = [delegate gridView:self widthForCellWithObject:object];
            cellFrame = CGRectMake(coordinate, 0.0, cellSize, self.bounds.size.height);
        }
        
        if ([delegate respondsToSelector:@selector(gridView:adjustCellFrame:)]) {
            cellFrame = [delegate gridView:self adjustCellFrame:cellFrame];
        }
        
        UIView<CBUIGridViewCell> *view = [dataSource gridView:self cellForItemAtIndex:index];
        view.frame = cellFrame;
        
        UITapGestureRecognizer *cellTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self 
                                                                                                   action:@selector(cellDidGetTapped:)];
        [view addGestureRecognizer:cellTapGestureRecognizer];
        [cellTapGestureRecognizer release];
        
        if (view.tag == selectedViewTag) {
            [view setSelected:YES animated:NO];
        }
        
        [scrollView addSubview:view];
        
        
        coordinate += cellSize + spacing;
    }
        
    if ([self isVertical]) {
        scrollView.contentSize = CGSizeMake(self.bounds.size.width, coordinate);
    } else {
        scrollView.contentSize = CGSizeMake(coordinate, self.bounds.size.height);
    }
}

- (void) setFrame:(CGRect)frame {
    [super setFrame:frame];
    
    scrollView.alwaysBounceVertical = [self isVertical];
    scrollView.alwaysBounceHorizontal = ![self isVertical];
}

- (void) selectViewWithTag:(int)tag {
    id selectedView = nil;
    if (selectedViewTag != 0) {
        selectedView = [scrollView viewWithTag:selectedViewTag];
        [selectedView setSelected:NO animated:NO];
    }
    
    selectedViewTag = tag;
    
    selectedView = [scrollView viewWithTag:selectedViewTag];
    [selectedView setSelected:YES animated:NO];
}

- (void) selectObjectAtIndex:(int)index {
    [self selectViewWithTag:index + TAG_PREFIX];
}

#pragma mark Gesture Recognition

- (void) cellDidGetTapped:(UITapGestureRecognizer*) tgr {
    [self selectViewWithTag:tgr.view.tag];
    
    if ([delegate respondsToSelector:@selector(gridView:didSelectItemAtIndex:)]) {
        [delegate gridView:self didSelectItemAtIndex:selectedViewTag - TAG_PREFIX];
    }
}

@end



@implementation CBUIGridViewCell

- (void) setObject:(id)object {
}

- (void) setSelected:(BOOL)selected animated:(BOOL)animated {
    
    if (selectedBackgroundView) {
        if (selected) {
            
            if (selectedBackgroundView.superview) {
                [selectedBackgroundView removeFromSuperview];
            }
            
            selectedBackgroundView.frame = self.bounds;
            
            if (backgroundView) {
                [self insertSubview:selectedBackgroundView 
                       aboveSubview:backgroundView];
            } else {
                [self insertSubview:selectedBackgroundView 
                            atIndex:0];
            }
            
        } else {
            
            if (selectedBackgroundView.superview) {
                [selectedBackgroundView removeFromSuperview];
            }
            
        }
    }
    
}

@end