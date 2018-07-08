//
//  MyCell.h
//  demo
//
//  Created by liman on 3/11/17.
//  Copyright © 2017 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FriendObject.h"
#import "MessageObject.h"
#import "OrderObject.h"

typedef enum : NSUInteger {
    MyBaseCellStyle_0 = 0, /**< 消息 */
    MyBaseCellStyle_1 = 1, /**< 交易记录 */
    MyBaseCellStyle_2 = 2, /**< 信用 */
    MyBaseCellStyle_3 = 3, /**< 地图搜索 */
    MyBaseCellStyle_4 = 4, /**< 好友 */
} MyBaseCellStyle;


@interface MyBaseCell : UITableViewCell

//model
@property (strong, nonatomic) AMapPOI *aMapPOI;
@property (strong, nonatomic) FriendObject *friendObject;
@property (strong, nonatomic) MessageObject *messageObject;
@property (strong, nonatomic) OrderObject *orderObject;

@property (strong, nonatomic) UIView *topView;

@property (strong, nonatomic) UIImageView *leftImageView;
@property (strong, nonatomic) UILabel *leftLabel;
@property (strong, nonatomic) UILabel *leftSubLabel;
@property (strong, nonatomic) UILabel *rightLabel;
@property (strong, nonatomic) UILabel *rightSubLabel;

//MyBaseCellStyle
@property (assign, nonatomic) MyBaseCellStyle myBaseCellStyle;

@end
