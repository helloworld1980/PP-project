//
//  NearbyCell.m
//  demo
//
//  Created by liman on 3/12/17.
//  Copyright © 2017 apple. All rights reserved.
//
#define kGap 12

#import "NearbyCell.h"

@implementation NearbyCell

#pragma mark - init
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        [self init_topView];
        [self init_leftImageView];
        [self init_leftLabel];
        [self init_leftSubLabel];
        [self init_rightLabel];
        
        //借
        [self _borrowImageView];
        [self _borrowLabel];
        //还
        [self _retuenImageView];
        [self _retuenLabel];
    }
    
    return self;
}

#pragma mark - private
- (void)init_topView
{
    _topView = [UIView new];
    _topView.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5"];
    [self.contentView addSubview:_topView];
}

- (void)init_leftImageView
{
    _leftImageView = [UIImageView new];
    [self.contentView addSubview:_leftImageView];
}

- (void)init_leftLabel
{
    _leftLabel = [UILabel new];
    _leftLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    _leftLabel.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:_leftLabel];
}
- (void)init_leftSubLabel
{
    _leftSubLabel = [UILabel new];
    _leftSubLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    _leftSubLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:_leftSubLabel];
}
- (void)init_rightLabel
{
    _rightLabel = [UILabel new];
    _rightLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    _rightLabel.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:_rightLabel];
}

//借
- (void)_borrowImageView
{
    _borrowImageView = [UIImageView new];
    [self.contentView addSubview:_borrowImageView];
}
- (void)_borrowLabel
{
    _borrowLabel = [UILabel new];
    [self.contentView addSubview:_borrowLabel];
    
    _borrowLabel.textColor = [UIColor colorWithHexString:@"#00bb52"];
    _borrowLabel.font = [UIFont systemFontOfSize:14];
}
//还
- (void)_retuenImageView
{
    _retuenImageView = [UIImageView new];
    [self.contentView addSubview:_retuenImageView];
}
- (void)_retuenLabel
{
    _retuenLabel = [UILabel new];
    [self.contentView addSubview:_retuenLabel];
    
    _retuenLabel.textColor = [UIColor colorWithHexString:@"#ff8f00"];
    _retuenLabel.font = [UIFont systemFontOfSize:14];
}

#pragma mark - layoutSubviews
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    /************************************* 赋值 ******************************************/
    _leftImageView.image = [UIImage imageNamed:@"shop"];
    _leftLabel.text = _model.shopName;
    _leftSubLabel.text = _model.address;//哈哈
    _rightLabel.text = [NSString stringWithFormat:@"%.1fkm", _model.distance.floatValue / 1000.0f];
    
    //借
    _borrowImageView.image = [UIImage imageNamed:@"111"];
    _borrowLabel.text = _model.statistic.inuse;
    //还
    _retuenImageView.image = [UIImage imageNamed:@"222"];
    _retuenLabel.text = _model.statistic.free;
    
    /*************************************** frame ****************************************/
    _topView.left = 0;
    _topView.top = 0;
    _topView.width = SCREEN_WIDTH;
    _topView.height = kGap;
    
    _leftImageView.left = kGap;
    _leftImageView.height = self.contentView.height - 4*kGap;
    _leftImageView.width = _leftImageView.height;
    _leftImageView.centerY = self.contentView.centerY + _topView.height/2;
    [_leftImageView jk_cornerRadius:_leftImageView.width/2 strokeSize:0 color:nil];
    
    _leftLabel.top = _leftImageView.top - 8;
    _leftLabel.left = _leftImageView.right + 1.5*kGap;
    [_leftLabel adjustWidth];
    [_leftLabel adjustHeight:0];
    _leftLabel.width = SCREEN_WIDTH - _leftImageView.width - 110;
    
    _leftSubLabel.left = _leftLabel.left;
    [_leftSubLabel adjustWidth];
    [_leftSubLabel adjustHeight:0];
    _leftSubLabel.centerY = _leftImageView.centerY;
    _leftSubLabel.width = SCREEN_WIDTH - _leftImageView.width - 42;
    
    _rightLabel.frame = _leftLabel.frame;
    [_rightLabel adjustWidth];
    _rightLabel.right = self.contentView.right - kGap;
    
    //借
    _borrowImageView.left = _leftSubLabel.left;
    _borrowImageView.width = 22;
    _borrowImageView.height = _borrowImageView.width;
    _borrowImageView.top = _leftSubLabel.bottom + 5;
    [_borrowImageView jk_cornerRadius:_borrowImageView.width/2 strokeSize:0 color:nil];

    _borrowLabel.left = _borrowImageView.right + (kGap - 8);
    [_borrowLabel adjustWidth];
    [_borrowLabel adjustHeight:0];
    _borrowLabel.centerY = _borrowImageView.centerY;
    
    //还
    _retuenImageView.frame = _borrowImageView.frame;
    _retuenImageView.left = _borrowLabel.right + (kGap - 4);
    
    _retuenLabel.frame = _borrowLabel.frame;
    [_retuenLabel adjustWidth];
    [_retuenLabel adjustHeight:0];
    _retuenLabel.left = _retuenImageView.right + (kGap - 8);
}

@end
