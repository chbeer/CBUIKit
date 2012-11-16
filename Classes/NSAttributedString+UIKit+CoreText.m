//
//  NSAttributedString+CoreText.m
//  CBUIKit
//
//  Created by Christian Beer on 09.11.12.
//
//

#import "NSAttributedString+UIKit+CoreText.h"

#import <CoreText/CoreText.h>


@implementation NSAttributedString (UIKit_CoreText)

- (id) initWithCoreTextAttributedString:(NSAttributedString*)string;
{
    NSMutableAttributedString *result = [[NSMutableAttributedString alloc] init];
    
    NSString *plainString = [self string];
    
    [self enumerateAttributesInRange:NSMakeRange(0, self.length)
                             options:0
                          usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop) {
                              NSString *plainSub = [plainString substringWithRange:range];
                              NSDictionary *convertedAttributes = [[self class] convertedAttributesForUIKit:attrs];
                              
                              NSAttributedString *sub = [[NSAttributedString alloc] initWithString:plainSub
                                                                                        attributes:convertedAttributes];
                              [result appendAttributedString:sub];
                          }];
    
    return result;
}

+ (id) attributedStringWithCoreTextAttributedString:(NSAttributedString*)string;
{
    return [[[self class] alloc] initWithCoreTextAttributedString:string];
}

+ (NSDictionary*) convertedAttributesForUIKit:(NSDictionary*)dict
{
    NSMutableDictionary *result = [NSMutableDictionary dictionaryWithCapacity:dict.count];
    
    [dict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        /*
         -- ignored:
         const CFStringRef kCTCharacterShapeAttributeName;
         const CFStringRef kCTKernAttributeName;
         const CFStringRef kCTLigatureAttributeName;
         const CFStringRef kCTForegroundColorAttributeName;
         const CFStringRef kCTForegroundColorFromContextAttributeName;
         const CFStringRef kCTStrokeWidthAttributeName;
         const CFStringRef kCTStrokeColorAttributeName;
         const CFStringRef kCTSuperscriptAttributeName;
         const CFStringRef kCTUnderlineColorAttributeName;
         const CFStringRef kCTUnderlineStyleAttributeName;
         const CFStringRef kCTVerticalFormsAttributeName;
         const CFStringRef kCTGlyphInfoAttributeName;
         const CFStringRef kCTRunDelegateAttributeName
         */
        if ([key isEqual:(id)kCTFontAttributeName]) {
            CTFontRef ctFont = (__bridge CTFontRef)(obj);
            // CTFont to UIFont conversion curtesy of @olemoritz: http://stackoverflow.com/a/6714885
            NSString *fontName = (__bridge NSString *)CTFontCopyName(ctFont, kCTFontPostScriptNameKey);
            CGFloat fontSize = CTFontGetSize(ctFont);
            UIFont *font = [UIFont fontWithName:fontName size:fontSize];
            [result setObject:font forKey:NSFontAttributeName];
        } else if ([key isEqual:(id)kCTParagraphStyleAttributeName]) {
            NSParagraphStyle *paraStyle = [[NSParagraphStyle alloc] init];
        } else {
            NSLog(@"ii ignored: %@", key);
        }
    }];
    
    return result;
}

@end
