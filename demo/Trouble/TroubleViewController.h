//
//  TroubleViewController.h
//  demo
//
//  Created by liman on 3/9/17.
//  Copyright © 2017 apple. All rights reserved.
//

#import "BaseViewController.h"
#import "TroubleView.h"
#import "LMShowImageView.h"
#import "LMPhotoBrowerController.h"

@interface TroubleViewController : BaseViewController <TroubleViewDelegate, LMShowImageViewDelegate, LMPhotoBrowerControllerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate,UITextViewDelegate>

//1.电量不足
@property (strong, nonatomic) TroubleView *troubleView1;
//2.借取失败
@property (strong, nonatomic) TroubleView *troubleView2;
//3.充电宝损坏
@property (strong, nonatomic) TroubleView *troubleView3;
//4.其他
@property (strong, nonatomic) TroubleView *troubleView4;

//描述view
@property (strong, nonatomic) UIView *contentView;
//描述textView
@property (strong, nonatomic) UITextView *textView;

//提交按钮
@property (strong, nonatomic) UIButton *submitBtn;

//拍照view
@property (strong, nonatomic) LMShowImageView *showImageView;
//图片数组
@property (strong, nonatomic) NSMutableArray *photoObjects;

@end
