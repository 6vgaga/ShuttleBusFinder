//
//  ShuttleBusViewController.h
//  ShuttleBus
//
//  Created by LiuWeiMac on 8/17/14.
//  Copyright (c) 2014 TR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IRevealControllerProperty.h"
#import <MapKit/MapKit.h>
#import "CDSideBarController.h"
#import "RestRequestor.h"

@class BusInfo;

@interface ShuttleBusViewController : UIViewController <IRevealControllerProperty, CLLocationManagerDelegate,MKMapViewDelegate, AsynCallCompletionNotify, CDSideBarControllerDelegate>
{
    NSArray* busScheduleArray;
    BusInfo* busInfo;
    CDSideBarController *sideBar;
}

@property NSArray* busScheduleArray;
@property BusInfo* busInfo;

@property (retain, nonatomic) IBOutlet MKMapView *mapView;

@property (assign, nonatomic) float longitudeValue;
@property (assign, nonatomic) float latitudeValue;
@property (weak, nonatomic) IBOutlet UISegmentedControl *workOrHomeSegment;
@property (weak, nonatomic) IBOutlet UILabel *busInfoLabel;
@property (weak, nonatomic) IBOutlet UIButton *configButton;

@end
