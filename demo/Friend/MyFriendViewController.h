//
//  MyFriendViewController.h
//  demo
//
//  Created by liman on 3/10/17.
//  Copyright © 2017 apple. All rights reserved.
//

#import "BaseViewController.h"

@interface MyFriendViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate>

//背景imageView
@property (strong, nonatomic) UIImageView *backgroudImageView;

//tableView
@property (strong, nonatomic) UITableView *tableView;

@end
