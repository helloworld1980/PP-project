//
//  CustomAnnotation.h
//  MapKit_demo
//
//  Created by liman on 15/7/2.
//  Copyright (c) 2015年 liman. All rights reserved.
//

#define REUSABLE_PIN_RED @"Red"
#define REUSABLE_PIN_GREEN @"Green"
#define REUSABLE_PIN_PURPLE @"Purple"

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface CustomAnnotation : NSObject <MKAnnotation>

@property (nonatomic,readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic,copy,readonly) NSString *title;
@property (nonatomic,copy,readonly) NSString *subtitle;
@property (nonatomic,unsafe_unretained) MKPinAnnotationColor pinColor;

// 李满 (是否自定义样式)
@property (assign, nonatomic) BOOL isCustom;

@property (assign, nonatomic) BOOL isFromSearchVC;

- (id)initWithCoordinates:(CLLocationCoordinate2D)paramCoordinates title:(NSString *)paramTitle subTitle:(NSString *)paramSubTitle isCustom:(BOOL)isCustom;

+ (NSString *)reusableIdentifierforPinColor:(MKPinAnnotationColor)paramColor;

@end
