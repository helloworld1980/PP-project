//
//  BaseSettingViewController.h
//   
//
//  Created by liman on 15/9/4.
//  Copyright (c) 2015年 liman. All rights reserved.
//
#import <UIKit/UIKit.h>
@class SettingItem;

typedef enum : NSUInteger {
    SwitchTypeNone = 0, /**< 不显示switch */
    SwitchTypeOn = 1, /**< 打开switch */
    SwitchTypeOff = 2, /**< 关闭switch */
} SwitchType;

@interface BaseSettingViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate>

/**< 组数组 描述TableView有多少组 */
@property (strong, nonatomic) NSMutableArray *groups;
/**< UITableView */
@property (strong, nonatomic) UITableView *tableView;
/**< 设置cells */
@property (strong, nonatomic) NSArray *cells;

/**
 *  初始化cell
 */
- (UITableViewCell *)settingTableView:(UITableView *)tableView settingItem:(SettingItem *)item cellForRowAtIndexPath:(NSIndexPath *)indexPath;

@end

//--------------------------------------------------------------------------------------------

@interface SettingGroupItem : NSObject

/** 组中的行数组 */
@property (strong, nonatomic) NSArray *items;

@end

//--------------------------------------------------------------------------------------------

@interface SettingItem : NSObject

/**< 标题 */
@property (strong, nonatomic) NSString *title;
/**< 副标题 */
@property (strong, nonatomic) NSString *subTitle;
/**< 图片 */
@property (strong, nonatomic) UIImage *image;
/**< SwitchType属性 */
@property (assign, nonatomic) SwitchType switchType;
/**< accessoryType属性 */
@property (assign, nonatomic) UITableViewCellAccessoryType accessoryType;
/**< 是否居中显示 */
@property (assign, nonatomic) BOOL center;

/**
 *  设置cell标题,副标题,图片,SwitchType属性,accessoryType属性,是否居中显示
 */
+ (instancetype)itemWithTitle:(NSString *)title subTitle:(NSString *)subTitle image:(UIImage *)image switchType:(SwitchType)switchType accessoryType:(UITableViewCellAccessoryType)accessoryType center:(BOOL)center;

@end