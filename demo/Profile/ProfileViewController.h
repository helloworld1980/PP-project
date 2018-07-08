//
//  ProfileViewController.h
//  demo
//
//  Created by liman on 3/10/17.
//  Copyright © 2017 apple. All rights reserved.
//

#import "BaseViewController.h"

@class ProfileViewController;
@protocol ProfileViewControllerDelegate <NSObject>

//头像更改
- (void)profileViewController:(ProfileViewController *)profileViewController newAvatarImage:(UIImage *)avatarImage;
//昵称更改
- (void)profileViewController:(ProfileViewController *)profileViewController newNickname:(NSString *)nickname;

@end

@interface ProfileViewController : BaseSettingViewController <BaseSettingCellDelegate, MyBaseEditViewControllerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

//传值: 头像,昵称
- (instancetype)initWithAvatarImage:(UIImage *)avatarImage nickname:(NSString *)nickname;

@property (weak, nonatomic) id <ProfileViewControllerDelegate> delegate;
@end
