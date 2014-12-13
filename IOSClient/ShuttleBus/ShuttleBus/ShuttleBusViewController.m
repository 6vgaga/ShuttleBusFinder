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

@synthesize busScheduleArray, busInfo;
@synthesize revealController;
@synthesize mapView;
@synthesize longitudeValue;
@synthesize latitudeValue;

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
    
    NSArray *imageList = @[[UIImage imageNamed:@"menuChat.png"], [UIImage imageNamed:@"menuUsers.png"], [UIImage imageNamed:@"menuMap.png"], [UIImage imageNamed:@"menuClose.png"]];
    sideBar = [[CDSideBarController alloc] initWithImages:imageList withMenuButton:self.configButton];
    sideBar.delegate = self;
    
    [sideBar insertMenuButtonOnView:[UIApplication sharedApplication].delegate.window atPosition:CGPointMake(self.view.frame.size.width - 70, 0)];
    
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
    
    self.lock = [[NSLock alloc] init];
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
                [self markBusCurrentLocation: arrayObject];
            }
        }
        else
            NSLog(@"can't get ShuttleLocation,err=", arrayObject.firstObject);
    };
    
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    RestRequestor * req= [[RestRequestor alloc] init];
    [req getReportedBusLineLocation:delegate.lineName  callback:callbackFun];
}

- (void)markBusCurrentLocation: (NSArray*) locationArray
{
    [self.mapView removeAnnotations:[self.mapView annotations]];
    
    if (self.busScheduleArray != nil)
    {
        [self markBusScheduleLocation];
    }
    
    if (locationArray != nil)
    {
        for (BusLocationInfo* info in locationArray) {
            //创建CLLocation 设置经纬度
            CLLocation *loc = [[CLLocation alloc]initWithLatitude:info->latitude longitude:info->longitude];
            CLLocationCoordinate2D coord = [loc coordinate];
            //创建标题
            NSString *titile = [NSString stringWithFormat:@"%@, %@",info->userID,info->time];
            MarkPoint *markPoint = [[MarkPoint alloc] initWithCoordinate:coord andTitle:titile];
            //添加标注
            [self.mapView addAnnotation:markPoint];
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
                [self markBusScheduleLocation];
                [self goToBusScheduleLocation];
            }
        }
        else
            NSLog(@"can't get ShuttleSchedule,err=", arrayObject.firstObject);
    };
    
    RestRequestor * req= [[RestRequestor alloc] init];
    [req getBusLineSchedule:self.busInfo->busLine  callback:callbackFun];
}

- (void)markBusScheduleLocation
{
    [self.mapView removeAnnotations:[self.mapView annotations]];
    
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
        //创建CLLocation 设置经纬度
        CLLocation *loc = [[CLLocation alloc]initWithLatitude:info->latitude longitude:info->longitude];
        CLLocationCoordinate2D coord = [loc coordinate];
        //创建标题
        NSString *titile = [NSString stringWithFormat:@"%@, %@",info->name,info->time];
        MarkPoint *markPoint = [[MarkPoint alloc] initWithCoordinate:coord andTitle:titile];
        //添加标注
        [self.mapView addAnnotation:markPoint];
    }
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
        return nil;
    if ([annotation isKindOfClass:[MyLocationAnnotation class]]) {
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
            UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            [rightButton addTarget:self
                            action:@selector(showDetails:)  //点击右边的按钮之后，显示另外一个页面
                  forControlEvents:UIControlEventTouchUpInside];
            customPinView.rightCalloutAccessoryView = rightButton;
            MyLocationAnnotation *myAnnotation = (MyLocationAnnotation *)annotation;
            UIImage *image = [UIImage imageNamed:@"myLocation.png"];
            customPinView.image = image;
            customPinView.opaque = YES;
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
    //创建CLLocation 设置经纬度
    CLLocation *loc = [[CLLocation alloc]initWithLatitude:self.latitudeValue longitude:self.longitudeValue];
    MyLocationAnnotation* myLocation = [[MyLocationAnnotation alloc] init];
    myLocation.title = [NSString stringWithFormat:@"%f,%f", self.latitudeValue, self.longitudeValue];
    myLocation.coordinate = [loc coordinate];
    
    [self.mapView addAnnotation:myLocation];
    
    [self uploadBusLocation];
}

- (void)uploadBusLocation
{
    RestRequestor * req = [[RestRequestor alloc] init];
    BusLocationInfo* aLoc=[[BusLocationInfo alloc] init];
    aLoc->longitude = self.longitudeValue;
    aLoc->latitude = self.latitudeValue;
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
    [self markBusScheduleLocation];
    [self goToBusScheduleLocation];
}

- (void)menuButtonClicked:(int)index
{
    // Execute what ever you want
}
@end
