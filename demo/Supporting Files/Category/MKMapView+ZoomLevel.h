//
//  MKMapView+ZoomLevel.h
//  silu
//
//  Created by liman on 8/7/15.
//  Copyright (c) 2015年 upintech. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface MKMapView (ZoomLevel)

- (void)setcenterCoordinate:(CLLocationCoordinate2D)centerCoordinate
    zoomLevel:(NSUInteger)zoomLevel
    animated:(BOOL)animated;

- (MKCoordinateRegion)coordinateRegionWithMapView:(MKMapView *)mapView
                                centerCoordinate:(CLLocationCoordinate2D)centerCoordinate
								andZoomLevel:(NSUInteger)zoomLevel;
- (NSUInteger)zoomLevel;

@end
