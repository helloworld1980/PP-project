//
//  BaseSettingViewController.m
//   
//
//  Created by liman on 15/9/4.
//  Copyright (c) 2015年 liman. All rights reserved.
//
#import "BaseSettingViewController.h"

@interface BaseSettingViewController ()

@end

@implementation BaseSettingViewController

#pragma mark - setter
- (void)setCells:(NSArray *)cells
{
    for (NSArray *items in cells) {
        
        SettingGroupItem *group = [SettingGroupItem new];
        group.items = items;
        
        [_groups addObject:group];
    }
}

#pragma mark - init
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _groups = [NSMutableArray array];
    
    [self initTableView];
}

#pragma mark - private
- (void)initTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, k_NaviH, SCREEN_WIDTH, SCREEN_HEIGHT - k_NaviH) style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _groups.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    SettingGroupItem *group = _groups[section];
    
    return group.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SettingGroupItem *group = _groups[indexPath.section];
    SettingItem *item = group.items[indexPath.row];
    
    return [self settingTableView:tableView settingItem:item cellForRowAtIndexPath:indexPath];
}

@end

//--------------------------------------------------------------------------------------------

@implementation SettingGroupItem

@end

//--------------------------------------------------------------------------------------------

@implementation SettingItem

+ (instancetype)itemWithTitle:(NSString *)title subTitle:(NSString *)subTitle image:(UIImage *)image switchType:(SwitchType)switchType accessoryType:(UITableViewCellAccessoryType)accessoryType center:(BOOL)center
{
    SettingItem *item = [SettingItem new];
    item.title = title;
    item.subTitle = subTitle;
    item.image = image;
    item.switchType = switchType;
    item.accessoryType = accessoryType;
    item.center = center;
    
    return item;
}

@end
