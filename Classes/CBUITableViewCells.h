//
//  CBUITableViewCells.h
//  CBUIKit
//
//  Created by Christian Beer on 16.01.12.
//  Copyright (c) 2012 Christian Beer. All rights reserved.
//

#import "CBUITableViewDataSource.h"

@interface CBUITableViewDefaultCell : UITableViewCell <CBUITableViewCell>

@property (nonatomic, strong) NSString *textLabelKeyPath;

@end

@interface CBUITableViewSubtitleCell : UITableViewCell <CBUITableViewCell>

@property (nonatomic, strong) NSString *textLabelKeyPath;
@property (nonatomic, strong) NSString *detailTextLabelKeyPath;

@end