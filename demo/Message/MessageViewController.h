//
//  MessageViewController.h
//  demo
//
//  Created by liman on 3/10/17.
//  Copyright © 2017 apple. All rights reserved.
//

#import "BaseViewController.h"
#import "MessageDetailViewController.h"

@interface MessageViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate,MessageDetailViewControllerDelegate>

//tableview
@property (strong, nonatomic) UITableView *tableView;

@end
