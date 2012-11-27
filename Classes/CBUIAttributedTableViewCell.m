//
//  CBUIAttributedTableViewCell.m
//  CBUIKit
//
//  Created by Christian Beer on 26.11.12.
//
//

#import "CBUIAttributedTableViewCell.h"

#import "CBUIAttributedLabel.h"

static CGFloat kHorizontalMargin = 10;

@implementation CBUIAttributedTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) return nil;
    
    CBUIAttributedLabel *label = [[CBUIAttributedLabel alloc] initWithFrame:CGRectInset(self.contentView.bounds, kHorizontalMargin, 0)];
    label.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.contentView addSubview:label];
    self.attributedLabel = label;
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
