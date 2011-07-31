//
//  CBNSAttributedString+DokuWiki.m
//  CBUIKit
//
//  Created by Christian Beer on 28.06.11.
//  Copyright 2011 Christian Beer. All rights reserved.
//

#import "CBNSAttributedString+DokuWiki.h"
#import <CoreText/CoreText.h>

// NOTE: this only supports the basic text formatting described here: http://www.dokuwiki.org/syntax
//
// "DokuWiki supports bold, italic, underlined and monospaced texts. Of course you 
// can combine all these.
// DokuWiki supports **bold**, //italic//, __underlined__ and ''monospaced'' texts.
// Of course you can **__//''combine''//__** all these."

typedef struct {
    BOOL bold, italic, underline, monospace;
    NSString *fontFamily;
    CGFloat fontSize;
} CBNSAttributedStringAttributes;

@interface NSAttributedString (DokuWiki_Private) 
- (NSAttributedString*) attributedStringWithString:(NSString*)temp attributes:(CBNSAttributedStringAttributes)attributes;
@end


@implementation NSAttributedString (DokuWiki)

- (id)initWithDokuWikiData:(NSData *)data options:(NSDictionary*)dict;
{
    return [self initWithDokuWikiString:[[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease] 
                                options:dict];
}
- (id)initWithDokuWikiString:(NSString *)string options:(NSDictionary*)dict;
{
    NSMutableAttributedString *result = [[NSMutableAttributedString alloc] init];
 
    NSScanner *scanner = [NSScanner scannerWithString:string];
    [scanner setCharactersToBeSkipped:nil];
    
    NSCharacterSet *dokuWikiBasicSyntaxCharacterSet = [NSCharacterSet characterSetWithCharactersInString:@"*/_'"];
    
    CBNSAttributedStringAttributes attributes = {NO, NO, NO, NO, @"Helvetica", 12.0};
    
    if ([dict objectForKey:@"FontFamily"]) {
        attributes.fontFamily = [dict objectForKey:@"FontFamily"];
    }
    if ([dict objectForKey:@"FontSize"]) {
        attributes.fontSize = [[dict objectForKey:@"FontSize"] floatValue];
    }
    
    NSString *temp = nil;
    while (![scanner isAtEnd]) {
        
        [scanner scanUpToCharactersFromSet:dokuWikiBasicSyntaxCharacterSet
                                intoString:&temp];
        
        if (temp) {
            [result appendAttributedString:[self attributedStringWithString:temp 
                                                                 attributes:attributes]];
        }
        
        // characters need to be paired to form a tag
        if ([scanner scanString:@"**" intoString:NULL]) {
            attributes.bold = !attributes.bold;
        } else if ([scanner scanString:@"//" intoString:NULL]) {
            attributes.italic = !attributes.italic;
        } else if ([scanner scanString:@"__" intoString:NULL]) {
            attributes.underline = !attributes.underline;
        } else if ([scanner scanString:@"''" intoString:NULL]) {
            attributes.monospace = !attributes.monospace;
        }
        
    }
    
    if (![scanner isAtEnd]) {
        [result appendAttributedString:[self attributedStringWithString:temp 
                                                             attributes:attributes]];
    }
    
    [self release];
    return result;
}

// convenience methods
+ (NSAttributedString *)attributedStringWithDokuWikiString:(NSString *)string options:(NSDictionary *)options;
{
    return [[[self alloc] initWithDokuWikiString:string options:options] autorelease];
}

#pragma mark - Helper

- (NSAttributedString*) attributedStringWithString:(NSString*)temp attributes:(CBNSAttributedStringAttributes)attributes
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
                              attributes.fontFamily, kCTFontFamilyNameAttribute,
                              [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:traits] 
                                                          forKey:(id)kCTFontSymbolicTrait], kCTFontTraitsAttribute,
                              nil];
    
    CTFontDescriptorRef descriptor = CTFontDescriptorCreateWithAttributes((CFDictionaryRef)fontAttr);
    CTFontRef font = CTFontCreateWithFontDescriptor(descriptor, attributes.fontSize, NULL);
    CFRelease(descriptor);
    
    NSMutableDictionary *attr = [NSMutableDictionary dictionary];
    [attr setObject:(id)font 
             forKey:(id)kCTFontAttributeName];
    if (attributes.underline) {
		[attr setObject:[NSNumber numberWithInteger:kCTUnderlineStyleSingle] 
                 forKey:(id)kCTUnderlineStyleAttributeName];
	}
    NSAttributedString *string = [[NSAttributedString alloc] initWithString:temp attributes:attr];
    return [string autorelease];
}

@end
