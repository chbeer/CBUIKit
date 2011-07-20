//
//  CBUIGridViewDataSource.h
//
//  Created by Christian Beer on 21.01.11.
//  Copyright 2011 Christian Beer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CBUIGridView.h"

#define TAG_PREFIX 0x45

@interface CBUIGridViewDataSource : NSObject <CBUIGridViewDataSource> {
    CBUIGridView *gridView;
    
    Class defaultGridCellClass;
    IBOutlet UIView<CBUIGridViewCell> *gridViewCell;
}

@property (assign) Class defaultGridCellClass;

- (id) initWithGridView:(CBUIGridView*)gridView;

- (Class) gridView:(CBUIGridView*)aGridView cellClassForObject:(id)object;

@end


@interface CBUIArrayGridViewDataSource : CBUIGridViewDataSource {
    
    NSMutableArray *_items;
    
}

@property (nonatomic, retain) NSMutableArray *items;

@end