//
//  LocationObject.h
//  MapKit_demo
//
//  Created by liman on 15/8/18.
//  Copyright (c) 2015年 liman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface LocationObject : NSObject

// 经纬度
@property (assign, nonatomic) CLLocationCoordinate2D coordinate;
// 标题
@property (strong, nonatomic) NSString *title;
// 副标题
@property (strong, nonatomic) NSString *subTitle;

// 是否自定义样式
@property (assign, nonatomic) BOOL isCustom;

@property (assign, nonatomic) BOOL isFromSearchVC;

- (instancetype)initWithCoordinate:(CLLocationCoordinate2D)coordinate title:(NSString *)title subTitle:(NSString *)subTitle isCustom:(BOOL)isCustom;

@end
