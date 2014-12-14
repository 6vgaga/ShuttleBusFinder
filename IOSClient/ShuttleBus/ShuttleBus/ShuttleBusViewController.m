//
//  ShuttleBusViewController.m
//  ShuttleBus
//
//  Created by LiuWeiMac on 8/17/14.
//  Copyright (c) 2014 TR. All rights reserved.
//

#import "ShuttleBusViewController.h"
#import "MarkPoint.h"
#import "BusLocationAnnotation.h"
#import "MyLocationAnnotation.h"
#import "AppDelegate.h"

@interface ShuttleBusViewController ()

@end

@implementation ShuttleBusViewController

@synthesize busScheduleArray, busLocationArray, busInfo;
@synthesize revealController;
@synthesize mapView;
@synthesize longitudeValue;
@synthesize latitudeValue;
@synthesize displaySchedule;
@synthesize displayLocation;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.displaySchedule = true;
    self.displayLocation = true;
    
    NSArray *imageList = @[[UIImage imageNamed:@"menuUsers.png"], [UIImage imageNamed:@"menuMap.png"], [UIImage imageNamed:@"menuClose.png"]];
    sideBar = [[CDSideBarController alloc] initWithImages:imageList withMenuButton:self.configButton];
    sideBar.delegate = self;

    [sideBar insertMenuButtonOnView:self.view atPosition:CGPointMake(self.view.frame.size.width - 70, 0)];
    
    [self.mapView setDelegate:self];
    [self.mapView setShowsUserLocation:YES];
    CLLocationManager *locationManager = [[CLLocationManager alloc] init];//创建位置管理器
    locationManager.delegate=self;//设置代理
    locationManager.desiredAccuracy=kCLLocationAccuracyBest;//指定需要的精度级别
    locationManager.distanceFilter=kCLDistanceFilterNone;//设置距离筛选器
    [locationManager startUpdatingLocation];//启动位置管理器
    
    [mapView setZoomEnabled:YES];
    [mapView setScrollEnabled:YES];
    
    // Initialize some params;
    self.busScheduleArray = nil;
    
    UITapGestureRecognizer *mTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPress:)];
    [self.mapView addGestureRecognizer:mTap];
}

- (void)viewDidAppear:(BOOL)animated     // Called when the view has been fully transitioned onto the screen. Default does nothing
{
    if (self.busScheduleArray == nil)
    {
        [self queryBusSchedule];
        [self displayBusInfo];
        self.navigationItem.title = self.busInfo->busLine;
    }
    
    if (self.timer == nil)
    {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:10
                                                      target:self
                                                    selector:@selector(queryBusLocation)
                                                    userInfo:nil
                                                     repeats:YES];
        [self.timer fire];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    if (self.timer != nil)
    {
        [self.timer isValid];
        
        self.timer = nil;
        
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
    }
}

-(void)queryBusLocation
{
    NSLog(@"start queryBusLocation");
    
    void (^callbackFun) (NSArray*,bool)= ^ (NSArray* arrayObject,bool isError) {
        if (!isError)
        {
            if (arrayObject != nil && arrayObject.count > 0)
            {
                self.busLocationArray = arrayObject;
                [self markBusLocation];
            }
        }
        else
            NSLog(@"can't get ShuttleLocation,err=", arrayObject.firstObject);
    };
    
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    RestRequestor * req= [[RestRequestor alloc] init];
    [req getReportedBusLineLocation:delegate.lineName  callback:callbackFun];
}

- (void)markBusLocation
{
    [self.mapView removeAnnotations: [self.mapView annotations]];
    
    if (self.busLocationArray != nil && self.displayLocation == true)
    {
        for (BusLocationInfo* info in self.busLocationArray) {
            CLLocation *loc = [[CLLocation alloc]initWithLatitude:info->latitude longitude:info->longitude];
            MyLocationAnnotation* myLocation = [[MyLocationAnnotation alloc] init];
            myLocation.title = [NSString stringWithFormat:@"%@, %@",info->userID,info->time];
            myLocation.coordinate = [loc coordinate];
            
            [self.mapView addAnnotation:myLocation];
        }
    }
    
    if (self.busScheduleArray != nil && self.displaySchedule == true)
    {
        for (BusScheduleStopInfo* info in self.busScheduleArray) {
            if (self.workOrHomeSegment.selectedSegmentIndex == 0)
            {
                if ([info->time compare:@"12:00"] == NSOrderedDescending)
                {
                    continue;
                }
            }
            else
            {
                if ([info->time compare:@"12:00"] != NSOrderedDescending)
                {
                    continue;
                }
            }
            CLLocation *loc = [[CLLocation alloc]initWithLatitude:info->latitude longitude:info->longitude];
            BusLocationAnnotation* busLocation = [[BusLocationAnnotation alloc] init];
            busLocation.title = [NSString stringWithFormat:@"%@, %@",info->name,info->time];
            busLocation.coordinate = [loc coordinate];
            
            [self.mapView addAnnotation:busLocation];
        }
    }
}

-(NSInteger) getReturnedObjectArray: (NSArray*) objectArray {
    
    return 0;
}

- (void) reportError:(NSString *)errorMsg {
    NSLog(@"REST API call failed, error=%@",errorMsg);
}

- (void)queryBusSchedule
{
    void (^callbackFun) (NSArray*,bool)= ^ (NSArray* arrayObject,bool isError) {
        if (!isError)
        {
            if (arrayObject != nil && arrayObject.count > 0)
            {
                self.busScheduleArray = arrayObject;
                [self markBusLocation];
                [self goToBusScheduleLocation];
            }
        }
        else
            NSLog(@"can't get ShuttleSchedule,err=", arrayObject.firstObject);
    };
    
    RestRequestor * req= [[RestRequestor alloc] init];
    [req getBusLineSchedule:self.busInfo->busLine  callback:callbackFun];
}

- (void)goToBusScheduleLocation
{
    if (self.busScheduleArray != nil && self.busScheduleArray.count > 0)
    {
        BusScheduleStopInfo* startInfo = nil;
        BusScheduleStopInfo* endInfo = nil;
        for (BusScheduleStopInfo* info in self.busScheduleArray) {
            if (self.workOrHomeSegment.selectedSegmentIndex == 0)
            {
                if ([info->time compare:@"12:00"] == NSOrderedDescending)
                {
                    continue;
                }
            }
            else
            {
                if ([info->time compare:@"12:00"] != NSOrderedDescending)
                {
                    continue;
                }
            }
            if (startInfo == nil)
            {
                startInfo = info;
            }
            
            endInfo = info;
        }
        double centerLatitude = (startInfo->latitude + endInfo->latitude)/2.0;
        double centerLongitude = (startInfo->longitude + endInfo->longitude)/2.0;
        CLLocation *centerLoc = [[CLLocation alloc]initWithLatitude:centerLatitude longitude:centerLongitude];
        
        CLLocation *startLoc = [[CLLocation alloc]initWithLatitude:startInfo->latitude longitude:startInfo->longitude];
        
        CLLocation *endLoc = [[CLLocation alloc]initWithLatitude:endInfo->latitude longitude:endInfo->longitude];
        
        CLLocationDistance meters =[startLoc distanceFromLocation:endLoc];
        
        CLLocationCoordinate2D loc = [centerLoc coordinate];
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(loc, meters * 1.4, meters * 1.4);
        [self.mapView setRegion:region animated:YES];
    }
}

- (void)displayBusInfo
{
    self.busInfoLabel.text = [NSString stringWithFormat:@"(%d seats) (%@ %@: %@)", self.busInfo->seatCount, self.busInfo->license, self.busInfo->driver, self.busInfo->phone];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    CLLocationCoordinate2D loc = [userLocation coordinate];
    //放大地图到自身的经纬度位置。
    //MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(loc, 250, 250);
    self.longitudeValue = loc.longitude;
    self.latitudeValue = loc.latitude;
    //[self.mapView setRegion:region animated:YES];
}

- (MKAnnotationView *)mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>)annotation {
    if ([annotation isKindOfClass:[MKUserLocation class]])
    {
        return nil;
    }
    else if ([annotation isKindOfClass:[MyLocationAnnotation class]])
    {
        // try to dequeue an existing pin view first
        static NSString* myAnnotationIdentifier = @"MyAnnotationIdentifier";
        MKPinAnnotationView* pinView = (MKPinAnnotationView *)
        [mapView dequeueReusableAnnotationViewWithIdentifier:myAnnotationIdentifier];
        if (!pinView)
        {
            // if an existing pin view was not available, create one
            MKAnnotationView* customPinView = [[MKAnnotationView alloc]
                                                initWithAnnotation:annotation reuseIdentifier:myAnnotationIdentifier];
            customPinView.canShowCallout = YES;  //很重要，运行点击弹出标签
            //UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            //[rightButton addTarget:self action:@selector(showDetails:) forControlEvents:UIControlEventTouchUpInside]; //点击右边的按钮之后，显示另外一个页面
            //customPinView.rightCalloutAccessoryView = rightButton;
            MyLocationAnnotation *myAnnotation = (MyLocationAnnotation *)annotation;
            UIImage *image = [UIImage imageNamed:@"myLocation.png"];
            customPinView.image = image;
            customPinView.opaque = YES;
            customPinView.frame = CGRectMake(0, 0, 30, 30);
            return customPinView;
        }
        else
        {
            pinView.annotation = annotation;
        }
        return pinView;
    }
    else if ([annotation isKindOfClass:[BusLocationAnnotation class]])
    {
        // try to dequeue an existing pin view first
        static NSString* busAnnotationIdentifier = @"BusAnnotationIdentifier";
        MKPinAnnotationView* pinView = (MKPinAnnotationView *)
        [mapView dequeueReusableAnnotationViewWithIdentifier:busAnnotationIdentifier];
        if (!pinView)
        {
            // if an existing pin view was not available, create one
            MKAnnotationView* customPinView = [[MKAnnotationView alloc]
                                               initWithAnnotation:annotation reuseIdentifier:busAnnotationIdentifier];
            customPinView.canShowCallout = YES;  //很重要，运行点击弹出标签
            BusLocationAnnotation *busAnnotation = (BusLocationAnnotation *)annotation;
            UIImage *image = [UIImage imageNamed:@"busLocation.png"];
            customPinView.image = image;
            customPinView.opaque = YES;
            customPinView.frame = CGRectMake(0, 0, 30, 30);
            return customPinView;
        }
        else
        {
            pinView.annotation = annotation;
        }
        return pinView;
    }
    return nil;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)showLeftMenu:(id)sender {
    [self.revealController toggleSidebar:!self.revealController.sidebarShowing duration:kGHRevealSidebarDefaultAnimationDuration];
}

- (IBAction)markYourPosition:(UIButton *)sender {
    [self uploadBusLocation: self.longitudeValue withLatitude:self.latitudeValue];
}

- (void)uploadBusLocation: (float) longtitude withLatitude: (float) latitude
{
    RestRequestor * req = [[RestRequestor alloc] init];
    BusLocationInfo* aLoc=[[BusLocationInfo alloc] init];
    aLoc->longitude = longtitude;
    aLoc->latitude = latitude;
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    aLoc->userID = delegate.userName;
    
    NSDate *date = [NSDate date];
    NSTimeInterval sec = [date timeIntervalSince1970];
    NSDate *epochNSDate = [[NSDate alloc] initWithTimeIntervalSince1970:sec];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *ct =[dateFormatter stringFromDate:epochNSDate];
    aLoc->time=ct;
    
    void (^callback) (NSArray* ,bool )= ^(NSArray* objArray,bool isError) {
        if (isError) {
            NSLog(@"post location failed, err=%@",objArray.firstObject);
        }
        else
        {
            NSLog(@"location upload is succesful");
        }
    };
    
    [req updateMyLocationToServer:delegate.lineName location:aLoc callback:callback];
}

- (IBAction)personLocation:(id)sender {
    CLLocation *selfLocation = [[CLLocation alloc]initWithLatitude:self.latitudeValue longitude:self.longitudeValue];
    
    CLLocationCoordinate2D loc = [selfLocation coordinate];
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(loc, 250, 250);
    [self.mapView setRegion:region animated:YES];
}

- (IBAction)busLocation:(id)sender {
    [self goToBusScheduleLocation];
}
- (IBAction)changeWorkOrHome:(id)sender {
    [self goToBusScheduleLocation];
}

- (void)menuButtonClicked:(int)index
{
    if (index == 0)
    {
        self.displaySchedule = !self.displaySchedule;
        [self markBusLocation];
    }
    else if (index == 1)
    {
        self.displayLocation = !self.displayLocation;
        [self markBusLocation];
    }
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    NSLog(@"Click Annotation %f %f", view.annotation.coordinate.longitude, view.annotation.coordinate.latitude);
}

- (void)tapPress:(UIGestureRecognizer*)gestureRecognizer
{
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    if (delegate.clickUpload == false)
    {
        return;
    }
    
    CGPoint touchPoint = [gestureRecognizer locationInView:self.mapView];//这里touchPoint是点击的某点在地图控件中的位置
    CLLocationCoordinate2D touchMapCoordinate =
    [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];//这里touchMapCoordinate就是该点的经纬度了
    
    NSLog(@"Click into Map %f %f", touchMapCoordinate.longitude, touchMapCoordinate.latitude);
    
    [self uploadBusLocation: touchMapCoordinate.longitude withLatitude:touchMapCoordinate.latitude];
}
@end
