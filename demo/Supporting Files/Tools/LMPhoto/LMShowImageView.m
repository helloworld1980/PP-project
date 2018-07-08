//
//  LMShowImageView.m
//  CheYouYuan
//
//  Created by liman on 12/4/15.
//  Copyright © 2015 LuYc. All rights reserved.
//

#import "LMShowImageView.h"
#import "LMPhotoObject.h"

@implementation LMShowImageView
{
    NSArray *_photoObjects;
}

#pragma mark - public

- (instancetype)initWithFrame:(CGRect)frame photoObjects:(NSArray *)photoObjects addType:(NSInteger)addType
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _photoObjects = photoObjects;
        _addType = addType;
        
        [self initCollectionView];
        
        
        if (_addType == 1) {
            // UICollectionView滑动到最后一个
            [_collectionView layoutIfNeeded];
            [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:_photoObjects.count inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
        }
    }
    
    return self;
}


// 更新数据源
- (void)updatePhotoObjects:(NSArray *)photoObjects
{
    _photoObjects = photoObjects;
    [_collectionView reloadData];
    
    // UICollectionView滑动到最后一个
    [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:_photoObjects.count - 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
}

- (void)updatePhotoObjects_test:(NSArray *)photoObjects
{
    _photoObjects = photoObjects;
    [_collectionView reloadData];
    
    // UICollectionView滑动到最后一个
    [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:_photoObjects.count inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
}

#pragma mark - private
- (void)initCollectionView
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    _collectionView = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:flowLayout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.showsHorizontalScrollIndicator = YES;
    _collectionView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_collectionView];
    
    
    //注册cell
    [_collectionView registerClass:[LMShowImageCell class] forCellWithReuseIdentifier:NSStringFromClass([LMShowImageCell class])];
}

#pragma mark - UICollectionViewDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (_addType == 1) {
        return [_photoObjects count] + 1;

    }
    return [_photoObjects count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LMShowImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([LMShowImageCell class]) forIndexPath:indexPath];
    if (!cell) {
        NSLog(@"自定义cell不可能进来");
    }
    
    if ([_photoObjects count] == 0)
    {
        cell.photoObject = nil;
        cell.addimageview.image = [UIImage imageNamed:@"camera_icon"];
        cell.myContentMode = UIViewContentModeScaleToFill;/**
                                *  图片排布样式:
                                UIViewContentModeScaleToFill;//默认
                                UIViewContentModeScaleAspectFit;//解决图片变形
                                */
        cell.addimageview.hidden = NO;
        cell.imageView.hidden    = YES;
    }
    else
    {
        if (indexPath.item > [_photoObjects count] - 1) {
            cell.photoObject = nil;
            cell.addimageview.image = [UIImage imageNamed:@"camera_icon"];
            cell.myContentMode = UIViewContentModeScaleToFill;/**
                                    *  图片排布样式:
                                    UIViewContentModeScaleToFill;//默认
                                    UIViewContentModeScaleAspectFit;//解决图片变形
                                    */
            cell.addimageview.hidden = NO;
            cell.imageView.hidden    = YES;
        }else{
            cell.photoObject = _photoObjects[indexPath.item];
            cell.myContentMode = UIViewContentModeScaleToFill;/**
                                    *  图片排布样式:
                                    UIViewContentModeScaleToFill;//默认
                                    UIViewContentModeScaleAspectFit;//解决图片变形
                                    */
            cell.addimageview.hidden = YES;
            cell.imageView.hidden    = NO;
        }
    }
    
    
    [cell setNeedsLayout];//必须手动触发-layoutSubviews
    
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout
//每一个cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(60, 60);
}

//设置每组的cell的边界
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

//cell的最小行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}

//cell的最小列间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    if ([_delegate respondsToSelector:@selector(lmShowImageView:didSelectedIndex:)]) {
        [_delegate lmShowImageView:self didSelectedIndex:indexPath.item];
    }
}

@end

