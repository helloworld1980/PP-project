//
//  LMPhotoBrowerController.h
//  CheYouYuan
//
//  Created by liman on 12/4/15.
//  Copyright © 2015 LuYc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LMShowImageCell.h"
#import "LMPhotoObject.h"

@class LMPhotoBrowerController;
@protocol LMPhotoBrowerControllerDelegate <NSObject>

// 重拍
- (void)photoBrowerController:(LMPhotoBrowerController *)photoBrowerController didSelectedRetake:(NSInteger)index;
// 删除
- (void)photoBrowerController:(LMPhotoBrowerController *)photoBrowerController didSelectedDelete:(NSInteger)index;

@end

@interface LMPhotoBrowerController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate>

@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) UILabel *tipLabel;//提示label

@property (strong, nonatomic) UIButton *retakeBtn;//重拍
@property (strong, nonatomic) UIButton *deleteBtn;//删除

- (instancetype)initWithPhotoObjects:(NSArray *)photoObjects index:(NSInteger)index forEdit:(BOOL)forEdit;

@property (weak, nonatomic) id <LMPhotoBrowerControllerDelegate> delegate;
@end
