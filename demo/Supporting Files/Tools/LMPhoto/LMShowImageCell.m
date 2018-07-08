//  LMShowImageCell.m
//  CheYouYuan
//
//  Created by liman on 12/4/15.
//  Copyright © 2015 LuYc. All rights reserved.
//

#import "LMShowImageCell.h"

@implementation LMShowImageCell

#pragma mark - init
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initImageView];
    }
    return self;
}

#pragma mark - private
- (void)initImageView
{
    _imageView = [UIImageView new];
    _addimageview = [UIImageView new];
    [self.contentView addSubview:_imageView];
    [self.contentView addSubview:_addimageview];
}

#pragma mark - layoutSubviews
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    /**
     *  图片排布样式:
     UIViewContentModeScaleToFill;//默认
     UIViewContentModeScaleAspectFit;//解决图片变形
     */
    _imageView.contentMode = _myContentMode;
    _addimageview.contentMode = _myContentMode;
    
    // frame
    _imageView.frame = self.contentView.bounds;
    _addimageview.frame = self.contentView.bounds;
    
    // 赋值
    if (_photoObject.image)
    {
        _imageView.image = _photoObject.image;
    }
    else
    {
        [_imageView sd_setImageWithURL:[NSURL URLWithString:_photoObject.imageUrl] placeholderImage:[UIImage imageNamed:@"no_image"]];
    }
}

@end
