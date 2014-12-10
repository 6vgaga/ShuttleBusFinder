//
//  MyLocationAnnotation.h
//  ShuttleBus
//
//  Created by 刘威 on 12/11/14.
//  Copyright (c) 2014 TR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface MyLocationAnnotation : NSObject<MKAnnotation>

@property CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;

@end
