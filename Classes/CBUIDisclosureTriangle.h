//
//  CBUIDisclosureTriangle.h
//  ArabianRaces2
//
//  Created by Christian Beer on 20.01.11.
//  Copyright 2011 Christian Beer. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CBUIDisclosureTriangle : UIView {
    BOOL state;
}

@property (nonatomic, assign) BOOL state;

- (void) setState:(BOOL)aState animated:(BOOL)animated;

@end
