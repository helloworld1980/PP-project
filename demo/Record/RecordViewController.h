//
//  RecordViewController.h
//  demo
//
//  Created by liman on 3/10/17.
//  Copyright © 2017 apple. All rights reserved.
//

#import "BaseViewController.h"

@interface RecordViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate>

//tableview
@property (strong, nonatomic) UITableView *tableView;

@end
