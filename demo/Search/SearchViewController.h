//
//  SearchViewController.h
//  demo
//
//  Created by liman on 3/9/17.
//  Copyright © 2017 apple. All rights reserved.
//

#import "BaseViewController.h"

@class SearchViewController;
@protocol SearchViewControllerDelegate <NSObject>

//点击了cell(火星坐标)
- (void)searchViewController:(SearchViewController *)searchViewController didSelectedCell:(LocationObject *)locationObject;

@end

@interface SearchViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate, AMapSearchDelegate>

//搜索view
@property (strong, nonatomic) UIView *searchView;
//搜索textfield
@property (strong, nonatomic) UITextField *textField;

//我的位置label1
@property (strong, nonatomic) UILabel *myLocationLabel1;
//我的位置label
@property (strong, nonatomic) UILabel *myLocationLabel;

//tableview
@property (strong, nonatomic) UITableView *tableView;

//高德POI
@property (strong, nonatomic) AMapSearchAPI *poiSearch;
@property (strong, nonatomic) AMapPOIKeywordsSearchRequest *poiRequest;
@property (strong, nonatomic) AMapPOIAroundSearchRequest *poiRequest2;


- (instancetype)initWithAddress:(NSString *)address;

@property (weak, nonatomic) id<SearchViewControllerDelegate> delegate;
@end
