//
//  CBGridViewDataSource.h
//
//  Created by Christian Beer on 21.01.11.
//  Copyright 2011 Christian Beer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CBUIGridView.h"

#define TAG_PREFIX 0x45

@interface CBUIGridViewDataSource : NSObject <CBGridViewDataSource> {
    CBUIGridView *gridView;
    
    Class defaultGridCellClass;
    IBOutlet UIView<CBGridViewCell> *gridViewCell;
}

@property (assign) Class defaultGridCellClass;

- (id) initWithGridView:(CBUIGridView*)gridView;

- (Class) gridView:(CBUIGridView*)aGridView cellClassForObject:(id)object;

@end
