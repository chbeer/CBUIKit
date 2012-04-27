//
//  CBNSAttributedString+DokuWiki.h
//  CBUIKit
//
//  Created by Christian Beer on 28.06.11.
//  Copyright 2011 Christian Beer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>


@interface NSAttributedString (DokuWiki)

- (id)initWithDokuWikiString:(NSString *)data options:(NSDictionary *)dict;
- (id)initWithDokuWikiData:(NSData *)data options:(NSDictionary *)dict;

// convenience methods
+ (NSAttributedString *)attributedStringWithDokuWikiString:(NSString *)string options:(NSDictionary *)options;


@end
