//
//  SettingViewController.m
//  demo
//
//  Created by liman on 3/4/17.
//  Copyright © 2017 apple. All rights reserved.
//

#import "ProfileViewController.h"
#import "ProfileCell.h"
#import "SignViewController.h"

@interface ProfileViewController ()
{
    UIImage *_avatarImage;
    NSString *_nickname;
}

@end

@implementation ProfileViewController
{
    //当前选中的indexpath
    NSIndexPath *_selectedIndexPath;
}

#pragma mark - tool
// 拍照
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

// 从相册选择
- (void)openPhotoAlbum
{
    UIImagePickerController *picker = [UIImagePickerController new];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];
}

//计算年龄
- (NSString *)calculateAge
{
    NSString *birth = [self stringFromTimeStamp:[UserObject sharedInstance].birthday];
//    birth = @"1990-5-22";
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    //生日
    NSDate *birthDay = [dateFormatter dateFromString:birth];
    //当前时间
    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
    NSDate *currentDate = [dateFormatter dateFromString:currentDateStr];
    NSLog(@"currentDate %@ birthDay %@",currentDateStr,birth);
    NSTimeInterval time=[currentDate timeIntervalSinceDate:birthDay];
    double age = ((double)time)/(3600*24*365);
    
    return toNSString((NSInteger)age);
}

// 时间戳---->年月日
- (NSString *)stringFromTimeStamp:(NSString *)totalSeconds
{
    NSString * timeStampString = totalSeconds;
    NSTimeInterval _interval=[timeStampString doubleValue] / 1000.0;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
    NSDateFormatter *objDateformat = [[NSDateFormatter alloc] init];
    [objDateformat setDateFormat:@"yyyy-MM-dd"];
    
    return [objDateformat stringFromDate: date];
}

//计算性别
- (NSString *)calculateSex
{
    NSString *sex = @"男";
    if ([[UserObject sharedInstance].sex isEqualToString:@"F"]) {
        sex = @"女";
    }
    
    return sex;
}


#pragma mark - public
//传值: 头像,昵称
- (instancetype)initWithAvatarImage:(UIImage *)avatarImage nickname:(NSString *)nickname
{
    self = [super init];
    if (self) {
        _avatarImage = avatarImage;
        _nickname = nickname;
    }
    return self;
}

#pragma mark - life
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"编辑资料";
    self.showNaviDismissItem = YES;

    
    NSString *xxx = nil;
    if ([[BalanceObject sharedInstance].deposit integerValue] == 0)
    {
        //未交押金
        xxx = @"未认证";
    }
    else
    {
        //已交押金
        xxx = @"已认证";
    }
    
    
    
    
    
    SettingItem *item1 = [SettingItem itemWithTitle:@"头像" subTitle:nil image:nil switchType:0 accessoryType:0 center:NO];
    SettingItem *item2 = [SettingItem itemWithTitle:@"昵称" subTitle:_nickname image:nil switchType:0 accessoryType:0 center:NO];
    SettingItem *item3 = [SettingItem itemWithTitle:@"性别" subTitle:[self calculateSex] image:nil switchType:0 accessoryType:0 center:NO];
    SettingItem *item4 = [SettingItem itemWithTitle:@"年龄" subTitle:[self calculateAge] image:nil switchType:0 accessoryType:0 center:NO];
    SettingItem *item5 = [SettingItem itemWithTitle:@"手机号" subTitle:[UserObject sharedInstance].phone image:nil switchType:0 accessoryType:0 center:NO];
    SettingItem *item6 = [SettingItem itemWithTitle:@"个性签名" subTitle:@"总要写点特别的吧" image:nil switchType:0 accessoryType:0 center:NO];
    SettingItem *item7 = [SettingItem itemWithTitle:@"实名认证" subTitle:xxx image:nil switchType:0 accessoryType:0 center:NO];

    

    
    self.cells = @[
                   @[item1, item2, item3, item4, item5, item6],
                   @[item7],
                   ];
    
    
}

#pragma mark - 父类方法
- (UITableViewCell *)settingTableView:(UITableView *)tableView settingItem:(SettingItem *)item cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProfileCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ProfileCell class])];
    if (!cell) {
        cell  = [[ProfileCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:NSStringFromClass([ProfileCell class])];
    }
    
    cell.item = item;
    cell.delegate = self;
    cell.avatarImage = _avatarImage;
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    _selectedIndexPath = indexPath;
    
    ProfileCell *cell = [self.tableView cellForRowAtIndexPath:_selectedIndexPath];
    NSString *value = cell.item.subTitle;
    
    
    if (indexPath.section == 0 && indexPath.row == 0)
    {
        //头像
        [UIActionSheet showInView:self.view withTitle:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"相机", @"从相册选择"] tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
            if (buttonIndex == 0) {
                //相机
                [self openCamera];
            }
            if (buttonIndex == 1) {
                //从相册选择
                [self openPhotoAlbum];
            }
        }];
    }
    if (indexPath.section == 0 && indexPath.row == 1)
    {
        //昵称
        MyBaseEditViewController *vc = [[MyBaseEditViewController alloc] initWithTitle:@"昵称" value:_nickname];
        vc.delegate = self;
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (indexPath.section == 0 && indexPath.row == 2)
    {
        //性别
        MyBaseEditViewController *vc = [[MyBaseEditViewController alloc] initWithTitle:@"性别" value:value];
        vc.delegate = self;
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (indexPath.section == 0 && indexPath.row == 3)
    {
        //年龄
        MyBaseEditViewController *vc = [[MyBaseEditViewController alloc] initWithTitle:@"年龄" value:value];
        vc.delegate = self;
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (indexPath.section == 0 && indexPath.row == 4)
    {
        //手机号
        [UIAlertView showWithMessage:@"不支持修改"];
    }
    if (indexPath.section == 0 && indexPath.row == 5)
    {
        //个性签名
        [self.navigationController pushViewController:[SignViewController new] animated:YES];
    }
    if (indexPath.section == 1 && indexPath.row == 0)
    {
        //实名认证
        [UIAlertView showWithMessage:@"不支持修改"];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return CGFLOAT_MIN;
    }
    
//    return tableView.sectionHeaderHeight;
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
//    return tableView.sectionFooterHeight;
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [UIView new];
    //    view.backgroundColor = [UIColor lightGrayColor];
    
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [UIView new];
    //    view.backgroundColor = [UIColor darkGrayColor];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
        return 88;
    }
    return 44;
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *image = info[UIImagePickerControllerOriginalImage];

    
    
    //21.上传用户头像
    [[HUDHelper sharedInstance] loading];
    [[APIService sharedInstance] uploadUserPhoto:image success:^(NSString *message) {
        
        DLog(message);
        [[HUDHelper sharedInstance] tipMessage:@"头像修改成功"];
        
        ProfileCell *cell = [self.tableView cellForRowAtIndexPath:_selectedIndexPath];
        cell.customImageView.image = image;
        
        if ([_delegate respondsToSelector:@selector(profileViewController:newAvatarImage:)]) {
            [_delegate profileViewController:self newAvatarImage:image];
        }
        
    } failure:^(NSString *errorStatus, NSString *errorMsg) {
        
        [[HUDHelper sharedInstance] stopLoading];
        [UIAlertView showWithMessage:errorMsg];
    }];
}

#pragma mark - MyBaseEditViewControllerDelegate
//修改后的值
- (void)myBaseEditViewController:(MyBaseEditViewController *)myBaseEditViewController title:(NSString *)title newValue:(NSString *)newValue
{
    ProfileCell *cell = [self.tableView cellForRowAtIndexPath:_selectedIndexPath];
    cell.item.subTitle = newValue;
    
    
    if ([title isEqualToString:@"昵称"]) {
        if ([_delegate respondsToSelector:@selector(profileViewController:newNickname:)]) {
            [_delegate profileViewController:self newNickname:newValue];
        }
    }
}

@end
