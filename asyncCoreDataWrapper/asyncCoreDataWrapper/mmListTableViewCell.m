//
//  mmListTableViewCell.m
//  asyncCoreDataWrapper
//
//  Created by LiMing on 14-6-25.
//  Copyright (c) 2014年 liming. All rights reserved.
//

#import "mmListTableViewCell.h"

@implementation mmListTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
