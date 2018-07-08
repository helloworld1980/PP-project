//
//  SettingCell.m
//  demo
//
//  Created by liman on 3/4/17.
//  Copyright © 2017 apple. All rights reserved.
//

#import "ProfileCell.h"

@implementation ProfileCell

#pragma mark - init
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self initCustomImageView];
    }
    
    return self;
}

#pragma mark - private
- (void)initCustomImageView
{
    _customImageView = [UIImageView new];
    [self.contentView addSubview:_customImageView];
}

#pragma mark - layoutSubviews
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.textLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    _customImageView.image = _avatarImage;
    
    if ([self.item.title isEqualToString:@"头像"])
    {
        _customImageView.frame = CGRectMake(self.contentView.width - 72, 14, 60, 60);
        [_customImageView jk_cornerRadius:_customImageView.width/2 strokeSize:0 color:nil];
    }
    else
    {
        _customImageView.frame = CGRectZero;
    }
}

@end
