//
//  MyCell.m
//  demo
//
//  Created by liman on 3/11/17.
//  Copyright © 2017 apple. All rights reserved.
//
#define kGap _kGap

#import "MyBaseCell.h"

@implementation MyBaseCell
{
    NSInteger _kGap;
}

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
        [self init_rightSubLabel];
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
- (void)init_rightSubLabel
{
    _rightSubLabel = [UILabel new];
    _rightSubLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    _rightSubLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:_rightSubLabel];
}

#pragma mark - layoutSubviews
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _kGap = 12;
    
    /************************************* 赋值 ******************************************/
    if (_myBaseCellStyle == MyBaseCellStyle_3)
    {
        //地图搜索
        _leftLabel.text = _aMapPOI.name;
        _leftSubLabel.text = _aMapPOI.address;
    }
    if (_myBaseCellStyle == MyBaseCellStyle_4)
    {
        //好友
        _kGap = 1;
        
        [_leftImageView sd_setImageWithURL:[NSURL URLWithString:_friendObject.photoUrl] placeholderImage:[UIImage imageNamed:@"morentouxiang"]];
        
        _leftLabel.text = _friendObject.loginName;//昵称
        if (!_leftLabel.text || [_leftLabel.text isEmpty]) {
            _leftLabel.text = _friendObject.realName;
        }
        if (!_leftLabel.text || [_leftLabel.text isEmpty]) {
            _leftLabel.text = _friendObject.phone;
        }
    }
    if (_myBaseCellStyle == MyBaseCellStyle_0)
    {
        //消息
        _leftSubLabel.text = _messageObject.title;
        _rightLabel.text = _messageObject.createDt;
        
        if ([_messageObject.msg_type isEqualToString:@"ORDER"]) {
            _leftLabel.text = @"订单类";
            _leftImageView.image = [UIImage imageNamed:@"order"];
        }else{
            _leftLabel.text = @"消息类";
            _leftImageView.image = [UIImage imageNamed:@"news"];
        }
        
        if ([_messageObject.status isEqualToString:@"READ"]) {
            _leftSubLabel.textColor = [UIColor colorWithHexString:@"#666666"];//已读
        }else{
            _leftSubLabel.textColor = [UIColor colorWithHexString:@"#459def"];//未读
        }
    }
    if (_myBaseCellStyle == MyBaseCellStyle_2)
    {
        //信用
        _leftLabel.text = @"钱包";
        _leftSubLabel.text = @"2016-11-22";
        _rightLabel.text = @"+100信用分";
    }
    if (_myBaseCellStyle == MyBaseCellStyle_1)
    {
        //测试2
//        _orderObject.Description = @"赠送";
//        _orderObject.Description = @"借用充电宝";
        
        //交易记录
        _leftLabel.text = _orderObject.Description;
        _leftSubLabel.text = _orderObject.createDt;
        
        _rightLabel.text = [_orderObject.totalFee stringByAppendingString:@"元"];
        if ([_orderObject.totalFee floatValue] > 0) {
            _rightLabel.text = [NSString stringWithFormat:@"+%@元", _orderObject.totalFee];
        }
        
        double fen = ([_orderObject.endDt doubleValue] - [_orderObject.startDt doubleValue]) / 1000 / 60;
//        fen = 42.0000;//测试2
        _rightSubLabel.text = [NSString stringWithFormat:@"借用%.0f分钟", fen];
        
        if ([_orderObject.Description isEqualToString:@"赠送"]) {
            _rightSubLabel.text = @"注册赠送";
        }
        
        
        if ([_orderObject.Description isEqualToString:@"退款"]) {
            _rightSubLabel.hidden = YES;
        }
        else if ([_orderObject.Description isEqualToString:@"充值"]) {
            _rightSubLabel.hidden = YES;
        }
        else if ([_orderObject.Description isEqualToString:@"充值余额"]) {
            _rightSubLabel.hidden = YES;
        }
        else if ([_orderObject.Description isEqualToString:@"充值押金"]) {
            _rightSubLabel.hidden = YES;
        }
        else {
            _rightSubLabel.hidden = NO;
        }
    }
    
    /*************************************** frame ****************************************/
    _topView.left = 0;
    _topView.top = 0;
    _topView.width = SCREEN_WIDTH;
    _topView.height = kGap;
    
    _leftImageView.top = _topView.bottom + kGap;
    _leftImageView.left = kGap;
    _leftImageView.height = self.contentView.height - 3*kGap;
    _leftImageView.width = _leftImageView.height;
    [_leftImageView jk_cornerRadius:_leftImageView.width/2 strokeSize:0 color:nil];
    
    _leftLabel.top = _leftImageView.top;
    _leftLabel.left = _leftImageView.right + 1.5*kGap;
    [_leftLabel adjustWidth];
    [_leftLabel adjustHeight:0];
    _leftLabel.width = SCREEN_WIDTH - _leftImageView.width - 42;
    
    _leftSubLabel.left = _leftLabel.left;
    [_leftSubLabel adjustWidth];
    [_leftSubLabel adjustHeight:0];
    _leftSubLabel.bottom = _leftImageView.bottom;
    _leftSubLabel.width = SCREEN_WIDTH - _leftImageView.width - 42;
    
    _rightLabel.frame = _leftLabel.frame;
    [_rightLabel adjustWidth];
    _rightLabel.right = self.contentView.right - kGap;
    
    _rightSubLabel.frame = _leftSubLabel.frame;
    [_rightSubLabel adjustWidth];
    _rightSubLabel.right = self.contentView.right - kGap;
    
    
    /************************************** frame (判断cell类型) *****************************************/
    if (_myBaseCellStyle == MyBaseCellStyle_0)
    {
        //消息
        _rightSubLabel.hidden = YES;
        _rightLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    }
    if (_myBaseCellStyle == MyBaseCellStyle_1)
    {
        //交易记录
        _leftImageView.hidden = YES;
        _leftLabel.left = kGap;
        _leftSubLabel.left = kGap;
    }
    if (_myBaseCellStyle == MyBaseCellStyle_2)
    {
        //信用
        _leftImageView.hidden = YES;
        _leftLabel.left = kGap;
        _leftSubLabel.left = kGap;
        _rightSubLabel.hidden = YES;
    }
    if (_myBaseCellStyle == MyBaseCellStyle_3)
    {
        //地图搜索
        _leftImageView.image = [UIImage imageNamed:@"location"];
        _leftImageView.width = 30;
        _leftImageView.height = 30;
        _leftImageView.y = 30;
        
        _leftLabel.left = _leftImageView.right + kGap;
        _leftSubLabel.left = _leftImageView.right + kGap;
        _rightLabel.hidden = YES;
        _rightSubLabel.hidden = YES;
        
        _leftLabel.width = SCREEN_WIDTH - _leftImageView.width - 42;
        _leftSubLabel.width = SCREEN_WIDTH - _leftImageView.width - 42;
    }
    if (_myBaseCellStyle == MyBaseCellStyle_4)
    {
        //好友
        _leftSubLabel.hidden = YES;
        _rightLabel.hidden = YES;
        _rightSubLabel.hidden = YES;
        
        _leftImageView.height = self.height - 20;
        _leftImageView.width = _leftImageView.height;
        _leftImageView.left = 10;
        _leftImageView.top = 10;
        [_leftImageView jk_cornerRadius:_leftImageView.width/2 strokeSize:0 color:nil];
        
        _leftLabel.centerY = _leftImageView.centerY;
    }
}

@end
