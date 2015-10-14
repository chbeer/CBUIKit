//
//  NSAttributedString+CoreText.h
//  CBUIKit
//
//  Created by Christian Beer on 09.11.12.
//
//

#import <UIKit/UIKit.h>

@interface NSAttributedString (UIKit_CoreText)

- (id) initWithCoreTextAttributedString:(NSAttributedString*)string;
+ (id) attributedStringWithCoreTextAttributedString:(NSAttributedString*)string;

@end
