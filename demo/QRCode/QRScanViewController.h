//
//  ScanViewController.h
//  demo
//
//  Created by liman on 3/6/17.
//  Copyright © 2017 apple. All rights reserved.
//
#define kSCAN_WINDOW_WIDTH      200
#define kMargin                 (SCREEN_WIDTH - kSCAN_WINDOW_WIDTH) / 2
#define kBorderW                (SCREEN_HEIGHT - kSCAN_WINDOW_WIDTH) / 2 - k_NaviH

#import "BaseViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "InputViewController.h"

@class QRScanViewController;
@protocol QRScanViewControllerDelegate <NSObject>

//借取成功
- (void)qrScanViewController:(QRScanViewController *)qrScanViewController borrowSuccess:(BorrowObject *)borrowObject;

@end

@interface QRScanViewController : BaseViewController <AVCaptureMetadataOutputObjectsDelegate>

//扫描区域
@property (strong, nonatomic) UIView *scanWindow;
//扫描图片
@property (strong, nonatomic) UIImageView *scanNetImageView;


//核心代码
@property (strong, nonatomic) AVCaptureDevice            *device;
@property (strong, nonatomic) AVCaptureDeviceInput       *input;
@property (strong, nonatomic) AVCaptureMetadataOutput    *output;
@property (strong, nonatomic) AVCaptureSession           *session;
@property (strong, nonatomic) AVCaptureVideoPreviewLayer *preview;


//电池image
@property (strong, nonatomic) UIImageView *batteryImageView;
//说明label
@property (strong, nonatomic) UILabel *label;
//输入编码(左边)
@property (strong, nonatomic) UIView *leftView;
//手电筒(右边)
@property (strong, nonatomic) UIView *rightView;

//扫描类型
@property (assign, nonatomic) ScanType scanType;

/**
 *  是否隐藏导航栏
 */
- (instancetype)initWithNaviBarHidden:(BOOL)naviBarHidden scanType:(ScanType)scanType;

@property (weak, nonatomic) id<QRScanViewControllerDelegate> delegate;
@end
