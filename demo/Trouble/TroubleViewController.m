//
//  TroubleViewController.m
//  demo
//
//  Created by liman on 3/9/17.
//  Copyright © 2017 apple. All rights reserved.
//
#define kGap 12

#import "TroubleViewController.h"

@implementation TroubleViewController
{
    //是否为重拍
    BOOL _isRetake;
    //重拍的index
    NSInteger _retakeIndex;
    
    //选择的类型
    NSString *_typeTitle;
}

#pragma mark - tool
- (void)openCamera
{
    // 检测是否禁用了相机
    if ([AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo] == AVAuthorizationStatusDenied || [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo] == AVAuthorizationStatusRestricted)
    {
        [UIAlertView showWithMessage:@"您已禁止\"PP充电\"访问您的相机, 请前往\"设置-隐私-相机\"打开"];
        return;
    }
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *picker = [UIImagePickerController new];
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.delegate = self;
        [self presentViewController:picker animated:YES completion:nil];
    }
    else
    {
        [UIAlertView showWithMessage:@"相机不可用"];
    }
}

// 将image加入PhotoObject数组, 并刷新数据
- (void)addImageToPhotoObjects:(UIImage *)image
{
    [_photoObjects removeLastObject];
    
    LMPhotoObject *photo = [LMPhotoObject new];
    photo.image = image;
    [_photoObjects addObject:photo];
    
    LMPhotoObject *photo2 = [LMPhotoObject new];
    photo2.image = [UIImage imageNamed:@"camera_icon"];
    photo2.takeCamera = YES;
    [_photoObjects addObject:photo2];
    
    // 刷新数据
    [_showImageView updatePhotoObjects:[_photoObjects copy]];
}

// 更新PhotoObject数组, 并刷新数据 (重拍)
- (void)updateImageToPhotoObjects:(UIImage *)image
{
    LMPhotoObject *photo = [LMPhotoObject new];
    photo.image = image;
    [_photoObjects replaceObjectAtIndex:_retakeIndex withObject:photo];
    
    // 刷新数据
    [_showImageView updatePhotoObjects:[_photoObjects copy]];
}

// 获取拍摄的图片数组
- (NSArray *)getMyImages
{
    NSMutableArray *photoObjects = [NSMutableArray array];
    for (LMPhotoObject *photoObject in _photoObjects) {
        if (!photoObject.takeCamera) {
            [photoObjects addObject:photoObject];
        }
    }
    
    NSMutableArray *images = [NSMutableArray array];
    for (LMPhotoObject *photoObject in photoObjects) {
        [images addObject:photoObject.image];
    }
    
    //测试2
//    return @[[UIImage imageNamed:@"test"]];
    
    return [images copy];
}

#pragma mark - life
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [k_NSNotificationCenter addObserver:self
                                             selector:@selector(changeContentViewPosition:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    [k_NSNotificationCenter addObserver:self selector:@selector(changeContentViewPosition:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
    self.title = @"故障上报";
    self.showNaviDismissItem = YES;
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5"];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHidden)];
    tap.cancelsTouchesInView = NO; //防止覆盖UICollectionCell的点击事件
    [self.view addGestureRecognizer:tap];
    
    //图片数组
    if (!_photoObjects) {
        _photoObjects = [NSMutableArray array];
    }


    
    
    //1.电量不足
    [self init_troubleView1];
    //2.借取失败
    [self init_troubleView2];
    //3.充电宝损坏
    [self init_troubleView3];
    //4.其他
    [self init_troubleView4];
    
    //描述view
    [self init_contentView];
    //描述textView
    [self init_textView];
    
    //提交按钮
    [self init_submitBtn];
    
    //拍照view
    [self init_showImageView];
    
    [self.view bringSubviewToFront:self.naviBarView];
}

- (void)dealloc
{
    [k_NSNotificationCenter removeObserver:self];
}

#pragma mark - private
//1.电量不足
- (void)init_troubleView1
{
    _troubleView1 = [[TroubleView alloc] initWithFrame:CGRectMake(kGap, k_NaviH + kGap, (SCREEN_WIDTH - kGap*3)/2, 44) title:@"电量不足"];
    [self.view addSubview:_troubleView1];
    
    _troubleView1.delegate = self;
}
//2.借取失败
- (void)init_troubleView2
{
    _troubleView2 = [[TroubleView alloc] initWithFrame:_troubleView1.frame title:@"借取失败"];
    _troubleView2.left = _troubleView1.right + kGap;
    [self.view addSubview:_troubleView2];
    
    _troubleView2.delegate = self;
}
//3.充电宝损坏
- (void)init_troubleView3
{
    _troubleView3 = [[TroubleView alloc] initWithFrame:_troubleView1.frame title:@"充电宝损坏"];
    _troubleView3.top = _troubleView1.bottom + kGap;
    [self.view addSubview:_troubleView3];
    
    _troubleView3.delegate = self;
}
//4.其他
- (void)init_troubleView4
{
    _troubleView4 = [[TroubleView alloc] initWithFrame:_troubleView1.frame title:@"其他"];
    _troubleView4.left = _troubleView3.right + kGap;
    _troubleView4.top = _troubleView2.bottom + kGap;
    [self.view addSubview:_troubleView4];
    
    _troubleView4.delegate = self;
}

//描述view
- (void)init_contentView
{
    _contentView = [UIView new];
    _contentView.left = kGap;
    _contentView.width = SCREEN_WIDTH - 2*kGap;
    _contentView.height = 128;
    _contentView.top = _troubleView4.bottom + kGap;
    [self.view addSubview:_contentView];
    
    _contentView.backgroundColor = [UIColor whiteColor];
}

//描述textView
- (void)init_textView
{
    _textView = [UITextView new];
    _textView.width = _contentView.width - 2 * 6;
    _textView.height = _contentView.height;
    _textView.left = 6;
    _textView.top = 0;
    [_contentView addSubview:_textView];
    
    _textView.textColor = [UIColor colorWithHexString:@"#333333"];
    _textView.font = [UIFont systemFontOfSize:14];
    [_textView jk_addPlaceHolder:@"问题详细描述"];
    _textView.delegate = self;
}

//提交按钮
- (void)init_submitBtn
{
    _submitBtn = [UIButton buttonWithType:0];
    _submitBtn.width = SCREEN_WIDTH - 4*kGap;
    _submitBtn.height = 44;
    _submitBtn.top = SCREEN_HEIGHT - _submitBtn.height - 1.5*kGap;
    _submitBtn.left = 2*kGap;
    [self.view addSubview:_submitBtn];
    
    [_submitBtn jk_cornerRadius:4 strokeSize:0 color:nil];
    [_submitBtn setBackgroundImage:[UIImage imageWithColor:k_MainColor] forState:0];
    [_submitBtn setTitle:@"提交" forState:0];
    [_submitBtn setTitleColor:[UIColor whiteColor] forState:0];
    [_submitBtn addTarget:self action:@selector(_submitBtnClick) forControlEvents:UIControlEventTouchUpInside];
}

//拍照view
- (void)init_showImageView
{
    // 图片
    LMPhotoObject *photo = [LMPhotoObject new];
    photo.image = [UIImage imageNamed:@"camera_icon"];
    photo.takeCamera = YES;
    [_photoObjects addObject:photo];
    
    _showImageView = [[LMShowImageView alloc] initWithFrame:CGRectMake(kGap, _contentView.bottom + kGap, _contentView.width, 80) photoObjects:[_photoObjects copy] addType:0];
    _showImageView.delegate = self;
    [_showImageView.collectionView setContentInset:UIEdgeInsetsMake(0, kGap, 0, kGap)];
    [self.view addSubview:_showImageView];
}

#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
        [self keyboardHidden];
        return NO;
    }
    
    return YES;
}

#pragma mark - LMShowImageViewDelegate
- (void)lmShowImageView:(LMShowImageView *)lmShowImageView didSelectedIndex:(NSInteger)index
{
    LMPhotoObject *photo = _photoObjects[index];
    if (photo.takeCamera)
    {
        _isRetake = NO;
        [self openCamera];
    }
    else
    {
        // 移除最后一个占位图片
        NSMutableArray *arr = [_photoObjects mutableCopy];
        [arr removeLastObject];
        
        // 跳到相册浏览器
        LMPhotoBrowerController *vc = [[LMPhotoBrowerController alloc] initWithPhotoObjects:[arr copy] index:index forEdit:YES];
        vc.delegate = self;
        [self presentViewController:vc animated:NO completion:nil];
    }
}

#pragma mark - LMPhotoBrowerControllerDelegate
// 重拍
- (void)photoBrowerController:(LMPhotoBrowerController *)photoBrowerController didSelectedRetake:(NSInteger)index
{
    [photoBrowerController dismissViewControllerAnimated:NO completion:nil];
    
    _isRetake = YES;
    _retakeIndex = index;
    [self openCamera];
}

// 删除
- (void)photoBrowerController:(LMPhotoBrowerController *)photoBrowerController didSelectedDelete:(NSInteger)index
{
    [_photoObjects removeObjectAtIndex:index];
    
    // 刷新数据
    [_showImageView updatePhotoObjects:[_photoObjects copy]];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    [[ALAssetsLibrary new] saveImage:image toAlbum:@"PP充电" completion:nil failure:nil];
    
    // 判断是否为重拍
    if (_isRetake)
    {
        // 更新PhotoObject数组, 并刷新数据 (重拍)
        [self updateImageToPhotoObjects:image];
    }
    else
    {
        // 将image加入PhotoObject数组, 并刷新数据
        [self addImageToPhotoObjects:image];
    }
}

#pragma mark - TroubleViewDelegate
- (void)troubleView:(TroubleView *)troubleView typeTitle:(NSString *)typeTitle selected:(BOOL)selected
{
    _troubleView1.selected = NO;
    [_troubleView1 judgeIfSelected];
    
    _troubleView2.selected = NO;
    [_troubleView2 judgeIfSelected];
    
    _troubleView3.selected = NO;
    [_troubleView3 judgeIfSelected];
    
    _troubleView4.selected = NO;
    [_troubleView4 judgeIfSelected];
    
    troubleView.selected = YES;
    [troubleView judgeIfSelected];
    
    
    _typeTitle = typeTitle;
}

#pragma mark - target action
//隐藏键盘
- (void)keyboardHidden
{
    [_textView resignFirstResponder];
}

//提交按钮
- (void)_submitBtnClick
{
    if (!_typeTitle || [_typeTitle isEmpty]) {
        [UIAlertView showWithMessage:@"未选择故障项目"];
        return;
    }
    
    if ([_textView.text isEmpty] || !_textView.text) {
        [UIAlertView showWithMessage:@"请填写问题描述"];
        return;
    }
    
    if ([_textView.text length] > 200) {
        [UIAlertView showWithMessage:@"问题描述限制200个字内"];
        return;
    }
    
    if ([[self getMyImages] count] == 0) {
        [UIAlertView showWithMessage:@"未拍摄故障照片"];
        return;
    }
    
    if ([[self getMyImages] count] > 1) {
        [UIAlertView showWithMessage:@"故障照片，目前仅支持一张"];
        return;
    }
    
    
    
    
    
    
    [[HUDHelper sharedInstance] loading];
    //25.故障申报
    [[APIService sharedInstance] reportFault_typeTitle:_typeTitle content:_textView.text image:[self getMyImages][0] bankCode:@"1341234" success:^(NSString *message) {
        
//        [[HUDHelper sharedInstance] tipMessage:message];
        
        [[HUDHelper sharedInstance] stopLoading];
        [UIAlertView showWithMessage:@"故障上报成功" tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
        
    } failure:^(NSString *errorStatus, NSString *errorMsg) {
        
        [[HUDHelper sharedInstance] stopLoading];
        [UIAlertView showWithMessage:errorMsg];
    }];
}

#pragma mark - notification
- (void)changeContentViewPosition:(NSNotification *)notification
{
    CGFloat keyboardHeight = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    if (notification.name == UIKeyboardWillShowNotification)
    {
        [UIView animateWithDuration:0.4 animations:^{
            _contentView.bottom = SCREEN_HEIGHT - keyboardHeight - kGap;
            _troubleView3.bottom = _contentView.top - kGap;
            _troubleView4.bottom = _contentView.top - kGap;
            _troubleView1.bottom = _contentView.top - kGap*2 - _troubleView1.height;
            _troubleView2.bottom = _contentView.top - kGap*2 - _troubleView1.height;
            _showImageView.top = SCREEN_HEIGHT - keyboardHeight;
        }];
    }
    else if(notification.name == UIKeyboardWillHideNotification)
    {
        [UIView animateWithDuration:0.4 animations:^{
            _troubleView1.top = k_NaviH + kGap;
            _troubleView2.top = k_NaviH + kGap;
            _troubleView3.top = k_NaviH + 2*kGap + _troubleView1.height;
            _troubleView4.top = k_NaviH + 2*kGap + _troubleView1.height;
            _contentView.top = k_NaviH + 3*kGap + 2*_troubleView1.height;
            _showImageView.top = _contentView.bottom + kGap;
        }];
    }
}

@end
