//
//  CreditViewController.h
//  demo
//
//  Created by liman on 3/10/17.
//  Copyright © 2017 apple. All rights reserved.
//

#import "BaseViewController.h"
#import "CreditHeaderView.h"

@interface CreditViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate>

//tableView
@property (strong, nonatomic) UITableView *tableView;

//传值: 信用分
- (instancetype)initWithScore:(NSString *)score;

@end
