//
//  CBUITableViewCells.m
//  CBUIKit
//
//  Created by Christian Beer on 16.01.12.
//  Copyright (c) 2012 Christian Beer. All rights reserved.
//

#import "CBUITableViewCells.h"

@implementation CBUITableViewDefaultCell

@synthesize textLabelKeyPath = _textLabelKeyPath;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    return [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
}

-(void)dealloc
{
    self.textLabelKeyPath = nil;

    [super dealloc];
}

- (void) setObject:(id)object;
{
    if (!self.textLabelKeyPath) {
        self.textLabel.text = object;
    } else {
        self.textLabel.text = [object valueForKeyPath:self.textLabelKeyPath];
    }
}

@end


@implementation CBUITableViewSubtitleCell

@synthesize textLabelKeyPath = _textLabelKeyPath;
@synthesize detailTextLabelKeyPath = _detailTextLabelKeyPath;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    return [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
}

-(void)dealloc
{
    self.textLabelKeyPath = nil;
    self.detailTextLabelKeyPath = nil;
    
    [super dealloc];
}

- (void) setObject:(id)object;
{
    self.textLabel.text = [object valueForKeyPath:self.textLabelKeyPath];
    self.detailTextLabel.text = [object valueForKeyPath:self.detailTextLabelKeyPath];
}

@end
