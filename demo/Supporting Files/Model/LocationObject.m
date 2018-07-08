//
//  LocationObject.m
//  MapKit_demo
//
//  Created by liman on 15/8/18.
//  Copyright (c) 2015年 liman. All rights reserved.
//

#import "LocationObject.h"

@implementation LocationObject

- (instancetype)initWithCoordinate:(CLLocationCoordinate2D)coordinate title:(NSString *)title subTitle:(NSString *)subTitle isCustom:(BOOL)isCustom
{
    self = [super init];
    if (self) {
        
        _coordinate = coordinate;
        _title = title;
        _subTitle = subTitle;
        _isCustom = isCustom;
    }
    return self;
}

@end
