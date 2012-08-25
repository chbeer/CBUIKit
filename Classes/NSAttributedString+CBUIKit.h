//
//  NSAttributedString+CBUIKit.h
//  CBUIKit
//
//  Created by Christian Beer on 24.08.12.
//
//

#import <Foundation/Foundation.h>

typedef struct {
    BOOL bold, italic, underline, monospace;
    CGColorRef textColor;
} CBNSAttributedStringAttributes;


@interface NSAttributedString (CBUIKit)

+ (NSAttributedString*) attributedStringWithString:(NSString*)string fontFamilyName:(NSString*)fontFamily fontSize:(CGFloat)fontSize
                                    fontAttributes:(CBNSAttributedStringAttributes)attributes;

+ (NSAttributedString*) attributedStringWithString:(NSString*)string fontName:(NSString*)fontName fontSize:(CGFloat)fontSize
                                         underline:(BOOL)underline textColor:(UIColor*)textColor;

@end