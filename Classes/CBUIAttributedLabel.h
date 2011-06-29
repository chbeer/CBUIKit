//
//  CBUIAttributedLabel.h
//  CBUIKit
//
//  Created by Christian Beer on 28.06.11.
//  Copyright 2011 Christian Beer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CBUIAttributedLabel : UIView {
    NSAttributedString *text;
}

@property (nonatomic, copy) NSAttributedString *text;

@end
