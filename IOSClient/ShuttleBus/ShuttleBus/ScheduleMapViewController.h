//
//  ScheduleMapViewController.h
//  ShuttleBus
//
//  Created by 刘威 on 12/14/14.
//  Copyright (c) 2014 TR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "ShuttleApI.h"

@interface ScheduleMapViewController : UIViewController <MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property BusScheduleStopInfo* info;

@end
