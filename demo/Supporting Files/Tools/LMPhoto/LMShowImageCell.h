//
//  LMShowImageCell.h
//  CheYouYuan
//
//  Created by liman on 12/4/15.
//  Copyright © 2015 LuYc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"
#import "UIImageView+Utils.h"
#import "LMPhotoObject.h"

@interface LMShowImageCell : UICollectionViewCell

// 模型
@property (strong, nonatomic) LMPhotoObject *photoObject;

@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UIImageView *addimageview;
// 图片排布样式
@property (assign, nonatomic) UIViewContentMode myContentMode;

@end
