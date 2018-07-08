//
//  LMPhotoBrowerController.m
//  CheYouYuan
//
//  Created by liman on 12/4/15.
//  Copyright © 2015 LuYc. All rights reserved.
//
#define kGap 4 //照片之间的间距

#import "LMPhotoBrowerController.h"

@interface LMPhotoBrowerController ()

@end

@implementation LMPhotoBrowerController
{
    NSMutableArray *_photoObjects;
    NSInteger _index;
    BOOL _forEdit;
    
    // 滑动到的当前cell
    LMShowImageCell *_currentCell;
}

#pragma mark - tool
- (void)scrollToIndex:(NSUInteger)index animated:(BOOL)animated
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
    [_collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:animated];
    
    //提示label
    _tipLabel.text = [NSString stringWithFormat:@"%lu / %lu", (long)_index + 1, (long)[_photoObjects count]];
}

// 删除后, 更新提示label
- (void)updateTipLabel
{
    NSInteger xxxx = [_collectionView currentScrolledIndex] + 1;
    if (xxxx > [_photoObjects count]) {
        xxxx --;
    }
    _tipLabel.text = [NSString stringWithFormat:@"%lu / %lu", (long)xxxx, (long)[_photoObjects count]];
}

#pragma mark - public
- (instancetype)initWithPhotoObjects:(NSArray *)photoObjects index:(NSInteger)index forEdit:(BOOL)forEdit
{
    self = [super init];
    if (self) {
        _photoObjects = [photoObjects mutableCopy];
        _index = index;
        _forEdit = forEdit;
    }
    
    return self;
}

#pragma mark - init
-(BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initCollectionView];
    
    [self initTipLabel];
    
    [self scrollToIndex:_index animated:NO];
    
    
    if (_forEdit)
    {
        //重拍
        [self initRetakeBtn];
        //删除
        [self initDeleteBtn];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [k_UIApplication setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [k_UIApplication setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
}

#pragma mark - private
- (void)initCollectionView
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    _collectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.showsHorizontalScrollIndicator = YES;
    _collectionView.pagingEnabled = YES;
    _collectionView.bounces = YES;
    _collectionView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:_collectionView];
    
    
    //注册cell
    [_collectionView registerClass:[LMShowImageCell class] forCellWithReuseIdentifier:NSStringFromClass([LMShowImageCell class])];
}

- (void)initTipLabel
{
    _tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 60, 30)];
    _tipLabel.centerX = self.view.centerX;
    _tipLabel.backgroundColor = [UIColor colorWithHexString:@"000000" withAlpha:0.3];
    _tipLabel.textColor = [UIColor whiteColor];
    _tipLabel.font = [UIFont systemFontOfSize:16];
    _tipLabel.textAlignment = NSTextAlignmentCenter;
    _tipLabel.layer.cornerRadius = 2;
    _tipLabel.layer.masksToBounds = YES;
    [self.view addSubview:_tipLabel];
}

//重拍
- (void)initRetakeBtn
{
    _retakeBtn = [UIButton buttonWithType:0];
    _retakeBtn.frame = CGRectMake(10, SCREEN_HEIGHT - 52, 60, 30);
    [_retakeBtn setTitle:@"重拍" forState:0];
    [_retakeBtn setTitleColor:[UIColor whiteColor] forState:0];
    _retakeBtn.layer.cornerRadius = 2;
    _retakeBtn.layer.masksToBounds = YES;
    _retakeBtn.backgroundColor = [UIColor colorWithHexString:@"000000" withAlpha:0.3];
    [_retakeBtn addTarget:self action:@selector(retakeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_retakeBtn];
    
    [_retakeBtn setEnlargeEdgeWithTop:10 right:10 bottom:22 left:10];
}

//删除
- (void)initDeleteBtn
{
    _deleteBtn = [UIButton buttonWithType:0];
    _deleteBtn.frame = _retakeBtn.frame;
    _deleteBtn.right = self.view.right - 10;
    [_deleteBtn setTitle:@"删除" forState:0];
    [_deleteBtn setTitleColor:[UIColor whiteColor] forState:0];
    _deleteBtn.layer.cornerRadius = 2;
    _deleteBtn.layer.masksToBounds = YES;
    _deleteBtn.backgroundColor = [UIColor colorWithHexString:@"000000" withAlpha:0.3];
    [_deleteBtn addTarget:self action:@selector(deleteBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_deleteBtn];
    
    [_deleteBtn setEnlargeEdgeWithTop:10 right:10 bottom:22 left:10];
}

#pragma mark - UICollectionViewDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_photoObjects count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LMShowImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([LMShowImageCell class]) forIndexPath:indexPath];
    if (!cell) {
        NSLog(@"自定义cell不可能进来");
    }
    
    cell.contentView.backgroundColor = [UIColor blackColor];
    cell.photoObject = _photoObjects[indexPath.item];
    cell.myContentMode = UIViewContentModeScaleAspectFit;/**
                            *  图片排布样式:
                            UIViewContentModeScaleToFill;//默认
                            UIViewContentModeScaleAspectFit;//解决图片变形
                            */
    [cell setNeedsLayout];//必须手动触发-layoutSubviews
    
    _currentCell = cell;
    
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout
//每一个cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.view.width - kGap, self.view.height);
}

//设置每组的cell的边界
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, kGap/2, 0, kGap/2);
}

//cell的最小行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return kGap;
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
    
    [self dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == _collectionView)
    {
        //提示label
        _tipLabel.text = [NSString stringWithFormat:@"%lu / %lu", (long)[scrollView currentScrolledIndex] + 1, (long)[_photoObjects count]];
    }
}

#pragma mark - target action
//重拍
- (void)retakeBtnClick
{
    LMPhotoObject *photoObject = _currentCell.photoObject;
    NSInteger index = [_photoObjects indexOfObject:photoObject];
    
    if ([_delegate respondsToSelector:@selector(photoBrowerController:didSelectedRetake:)]) {
        [_delegate photoBrowerController:self didSelectedRetake:index];
    }
}

//删除
- (void)deleteBtnClick
{
    LMPhotoObject *photoObject = _currentCell.photoObject;
    NSInteger index = [_photoObjects indexOfObject:photoObject];
    
    [_photoObjects removeObject:photoObject];
    [_collectionView reloadData];
    
    // 判断是否删除完了
    if ([_photoObjects count] == 0)
    {
        [self dismissViewControllerAnimated:NO completion:nil];
    }
    else
    {
        // 删除后, 更新提示label
        [self updateTipLabel];
    }

    
    if ([_delegate respondsToSelector:@selector(photoBrowerController:didSelectedDelete:)]) {
        [_delegate photoBrowerController:self didSelectedDelete:index];
    }
}

@end
