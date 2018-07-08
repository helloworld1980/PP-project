//
//  LMShowImageView.h
//  CheYouYuan
//
//  Created by liman on 12/4/15.
//  Copyright © 2015 LuYc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LMShowImageCell.h"

@class LMShowImageView;
@protocol LMShowImageViewDelegate <NSObject>

- (void)lmShowImageView:(LMShowImageView *)lmShowImageView didSelectedIndex:(NSInteger)index;

@end

@interface LMShowImageView : UIView <UICollectionViewDataSource,UICollectionViewDelegate>

@property (strong, nonatomic) UICollectionView *collectionView;
@property (assign, nonatomic) NSInteger addType; //是否可添加照片


- (instancetype)initWithFrame:(CGRect)frame photoObjects:(NSArray *)photoObjects addType:(NSInteger)addType;


// 更新数据源
- (void)updatePhotoObjects:(NSArray *)photoObjects;
- (void)updatePhotoObjects_test:(NSArray *)photoObjects;

@property (weak, nonatomic) id <LMShowImageViewDelegate> delegate;
@end




