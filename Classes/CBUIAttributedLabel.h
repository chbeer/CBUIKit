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

@class CBUIAttributedLabel;
@class CBUIAttributedLabelLink;


extern NSString * const kCBCTHighlightedForegroundColorAttributeName;
extern NSString * const kCBCTDefaultForegroundColorAttributeName;

extern NSString * const kCBUILinkAttribute;


@protocol CBUIAttributedLabelDelegate <NSObject>

- (void) attributedLabel:(CBUIAttributedLabel*)label didTapOnLink:(CBUIAttributedLabelLink*)link;

@end


@interface CBUIAttributedLabel : UILabel {
    CTFramesetterRef _framesetter;
}

@property (nonatomic, copy) NSAttributedString *attributedText;

@property (nonatomic, assign) VerticalAlignment verticalAlignment;

@property (nonatomic, weak) id <CBUIAttributedLabelDelegate> delegate;


+ (CGSize) sizeOfAttributedString:(NSAttributedString*)attributedText thatFits:(CGSize)size;

@end


@interface CBUIAttributedLabelLink : NSObject

@property (nonatomic, assign) NSRange range;
@property (nonatomic, assign) CGRect  frame;

@property (nonatomic, copy) NSString *link;

@end
