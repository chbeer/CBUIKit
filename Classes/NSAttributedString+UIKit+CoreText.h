//
//  NSAttributedString+CoreText.h
//  CBUIKit
//
//  Created by Christian Beer on 09.11.12.
//
//

#import <Foundation/Foundation.h>

@interface NSAttributedString (UIKit_CoreText)

- (id) initWithCoreTextAttributedString:(NSAttributedString*)string;
+ (id) attributedStringWithCoreTextAttributedString:(NSAttributedString*)string;

@end
