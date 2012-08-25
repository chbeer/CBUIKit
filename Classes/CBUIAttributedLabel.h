//
//  CBUIAttributedLabel.h
//  CBUIKit
//
//  Created by Christian Beer on 28.06.11.
//  Copyright 2011 Christian Beer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>

#import "CBUIVerticalAlignedLabel.h"


@interface CBUIAttributedLabel : UILabel {
    CTFramesetterRef _framesetter;
}

@property (nonatomic, copy) NSAttributedString *attributedText;

@property (nonatomic, assign) VerticalAlignment verticalAlignment;


+ (CGSize) sizeOfAttributedString:(NSAttributedString*)attributedText thatFits:(CGSize)size;

@end
