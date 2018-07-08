//
//  NearbyViewController.h
//  demo
//
//  Created by liman on 3/12/17.
//  Copyright © 2017 apple. All rights reserved.
//

#import "BaseViewController.h"

@interface NearbyViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate>

//tableview
@property (strong, nonatomic) UITableView *tableView;

@end
