//
//  CBUIVerticalAlignedLabel.h
//  CBUIKit
//
//  Created by Christian Beer on 27.01.12.
//  Copyright (c) 2012 Christian Beer. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum VerticalAlignment {
    VerticalAlignmentTop = 0,
    VerticalAlignmentMiddle = 1,
    VerticalAlignmentBottom = 2,
} VerticalAlignment;

@interface CBUIVerticalAlignedLabel : UILabel

@property (nonatomic, assign) VerticalAlignment verticalAlignment;

@end