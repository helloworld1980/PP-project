//
//  NearbyCell.h
//  demo
//
//  Created by liman on 3/12/17.
//  Copyright © 2017 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NearbyCell : UITableViewCell

@property (strong, nonatomic) UIView *topView;

//model
@property (strong, nonatomic) StationObject *model;

@property (strong, nonatomic) UIImageView *leftImageView;
@property (strong, nonatomic) UILabel *leftLabel;
@property (strong, nonatomic) UILabel *leftSubLabel;
@property (strong, nonatomic) UILabel *rightLabel;

//借
@property (strong, nonatomic) UIImageView *borrowImageView;
@property (strong, nonatomic) UILabel *borrowLabel;
//还
@property (strong, nonatomic) UIImageView *retuenImageView;
@property (strong, nonatomic) UILabel *retuenLabel;

@end
