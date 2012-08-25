//
//  NSAttributedString+CBUIKit.m
//  CBUIKit
//
//  Created by Christian Beer on 24.08.12.
//
//

#import <CoreText/CoreText.h>

#import "NSAttributedString+CBUIKit.h"

@implementation NSAttributedString (CBUIKit)

+ (NSAttributedString*) attributedStringWithString:(NSString*)string fontFamilyName:(NSString*)fontFamily fontSize:(CGFloat)fontSize
                                    fontAttributes:(CBNSAttributedStringAttributes)attributes
{
    CTFontSymbolicTraits traits = 0;
    if (attributes.bold)
	{
		traits |= kCTFontBoldTrait;
	}
	if (attributes.italic)
	{
		traits |= kCTFontItalicTrait;
	}
	if (attributes.monospace)
	{
		traits |= kCTFontMonoSpaceTrait;
	}
    
    NSDictionary *fontAttr = [NSDictionary dictionaryWithObjectsAndKeys:
                              fontFamily, kCTFontFamilyNameAttribute,
                              [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:traits]
                                                          forKey:(id)kCTFontSymbolicTrait], kCTFontTraitsAttribute,
                              nil];
    
    CTFontDescriptorRef descriptor = CTFontDescriptorCreateWithAttributes((CFDictionaryRef)fontAttr);
    CTFontRef font = CTFontCreateWithFontDescriptor(descriptor, fontSize, NULL);
    CFRelease(descriptor);
    
    NSMutableDictionary *attr = [NSMutableDictionary dictionary];
    [attr setObject:(id)font
             forKey:(id)kCTFontAttributeName];
    
    if (underline) {
        [attr setObject:[NSNumber numberWithInteger:kCTUnderlineStyleSingle]
                 forKey:(id)kCTUnderlineStyleAttributeName];
    }
    
    if (attributes.textColor) {
        [attr setObject:(id)attributes.textColor forKey:(id)kCTForegroundColorAttributeName];
    }
    
    [attr setObject:[NSNull null] forKey:@"NSKernAttributeName"];
    [attr setObject:[NSNumber numberWithInt:2] forKey:@"NSLigatureAttributeName"];
    
    
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:string
                                                                     attributes:attr];
    
    CFRelease(font);
    
    return attrString;
}

+ (NSAttributedString*) attributedStringWithString:(NSString*)string fontName:(NSString*)fontName fontSize:(CGFloat)fontSize
                                         underline:(BOOL)underline textColor:(UIColor*)textColor
{
    CTFontRef font = CTFontCreateWithName((CFStringRef)fontName, fontSize, NULL);
    
    NSMutableDictionary *attr = [NSMutableDictionary dictionary];
    [attr setObject:(id)font
             forKey:(id)kCTFontAttributeName];
    
    if (underline) {
        [attr setObject:[NSNumber numberWithInteger:kCTUnderlineStyleSingle]
                 forKey:(id)kCTUnderlineStyleAttributeName];
    }
    if (textColor) {
        [attr setObject:(id)[textColor CGColor] forKey:(id)kCTForegroundColorAttributeName];
    }
        
    
    [attr setObject:[NSNull null] forKey:@"NSKernAttributeName"];
    [attr setObject:[NSNumber numberWithInt:2] forKey:@"NSLigatureAttributeName"];
    
    
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:string
                                                                     attributes:attr];
    
    CFRelease(font);
    
    return attrString;
}

#pragma mark html

+ (NSAttributedString*) parseHTMLString:(NSString*)string fontFamilyName:(NSString*)fontFamily fontSize:(CGFloat)fontSize
{
    NSScanner *scanner = [NSScanner scannerWithString:string];
    scanner.charactersToBeSkipped = nil;
    
    NSMutableAttributedString *result = [[NSMutableAttributedString alloc] init];
    
    NSString *scanned = nil;
    CBNSAttributedStringAttributes attributes = {NO, NO, NO, NO};
    BOOL found = YES;
    while (![scanner isAtEnd] && found) {
        found = NO;
        
        if ([scanner scanUpToString:@"<" intoString:&scanned]) {
            [result appendAttributedString:[self attributedStringWithString:scanned fontFamilyName:fontFamily fontSize:fontSize fontAttributes:attributes]];
            found = YES;
        }
        
        if ([scanner scanString:@"<" intoString:nil]) {
            NSString *tag = nil;
            BOOL tagScanned = [scanner scanUpToString:@">" intoString:&tag];
            
            if (tagScanned) {
                [scanner scanString:@">" intoString:nil];
                
                if ([@"br" isEqualToString:tag] || [@"br/" isEqualToString:tag]) {
                    NSAttributedString *br = [[NSAttributedString alloc] initWithString:@"\u2028"];
                    [result appendAttributedString:br];
                    [br release];
                } else if ([@"b" isEqualToString:tag]) {
                    attributes.bold = YES;
                } else if ([@"/b" isEqualToString:tag]) {
                    attributes.bold = NO;
                } else if ([@"i" isEqualToString:tag]) {
                    attributes.italic = YES;
                } else if ([@"/i" isEqualToString:tag]) {
                    attributes.italic = NO;
                } else if ([@"u" isEqualToString:tag]) {
                    attributes.underline = YES;
                } else if ([@"/u" isEqualToString:tag]) {
                    attributes.underline = NO;
                } else if ([@"tt" isEqualToString:tag]) {
                    attributes.monospace = YES;
                } else if ([@"/tt" isEqualToString:tag]) {
                    attributes.monospace = NO;
                } else if ([@"code" isEqualToString:tag]) {
                    attributes.monospace = YES;
                } else if ([@"/code" isEqualToString:tag]) {
                    attributes.monospace = NO;
                }
                
                found = YES;
            }
        }
    }
    
    if (![scanner isAtEnd]) {
        NSString *string = [[scanner string] substringFromIndex:[scanner scanLocation]];
        [result appendAttributedString:[self attributedStringWithString:string fontFamilyName:fontFamily fontSize:fontSize fontAttributes:attributes]];
    }
    
    return  result;
}

@end


@implementation NSMutableAttributedString (CBUIKit)

- (void) appendAttributedStringWithString:(NSString*)string fontFamilyName:(NSString*)fontFamily fontSize:(CGFloat)fontSize fontAttributes:(CBNSAttributedStringAttributes)attributes
{
    [self appendAttributedString:[NSAttributedString attributedStringWithString:string fontFamilyName:fontFamily fontSize:fontSize fontAttributes:attributes]];
}

@end