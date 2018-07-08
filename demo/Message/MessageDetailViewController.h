//
//  MessageDetailViewController.h
//  demo
//
//  Created by liman on 3/16/17.
//  Copyright © 2017 apple. All rights reserved.
//

#import "BaseViewController.h"

@class MessageDetailViewController;
@protocol MessageDetailViewControllerDelegate <NSObject>

//消息已读
- (void)messageDetailViewController:(MessageDetailViewController *)messageDetailViewController didReadMessage:(MessageObject *)messageObject;

@end

@interface MessageDetailViewController : BaseViewController

//背景view
@property (strong, nonatomic) UIView *bgView;

//时间label
@property (strong, nonatomic) UILabel *timeLabel;

//内容label
@property (strong, nonatomic) UILabel *contentLabel;

- (instancetype)initWithMessageObject:(MessageObject *)messageObject;

@property (weak, nonatomic) id <MessageDetailViewControllerDelegate> delegate;
@end
