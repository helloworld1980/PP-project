//
//  CustomAnnotation.m
//  MapKit_demo
//
//  Created by liman on 15/7/2.
//  Copyright (c) 2015年 liman. All rights reserved.
//

#import "CustomAnnotation.h"

@implementation CustomAnnotation
@synthesize coordinate,title,subtitle,pinColor;

- (id)initWithCoordinates:(CLLocationCoordinate2D)paramCoordinates title:(NSString *)paramTitle subTitle:(NSString *)paramSubTitle isCustom:(BOOL)isCustom
{
    self = [super init];
    
    if (self) {
        
        coordinate = paramCoordinates;
        title = paramTitle;
        subtitle = paramSubTitle;
        _isCustom = isCustom;
    }
    
    return self;
}

+ (NSString *)reusableIdentifierforPinColor:(MKPinAnnotationColor)paramColor
{
    NSString *result = nil;
    
    switch (paramColor) {
            
        case MKPinAnnotationColorRed:{
            
            result = REUSABLE_PIN_RED;
            
            break;
        }
            
        case MKPinAnnotationColorGreen:{
            
            result = REUSABLE_PIN_GREEN;
            
            break;
        }
            
        case MKPinAnnotationColorPurple:{
            
            result = REUSABLE_PIN_PURPLE;
            
            break;
        }
    }
    
    return result;
}

@end
