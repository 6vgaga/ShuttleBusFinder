//
//  ShuttleBusViewController.m
//  ShuttleBus
//
//  Created by LiuWeiMac on 8/17/14.
//  Copyright (c) 2014 TR. All rights reserved.
//

#import "ShuttleBusViewController.h"
#import "MarkPoint.h"
//#import "BusLineOperator.h"
//#import "BusInfo.h"
//#import "BusScheduleStopInfo.h"

@interface ShuttleBusViewController ()

@end

@implementation ShuttleBusViewController

@synthesize lineName, busScheduleArray, busInfo;
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
}

- (void)viewDidAppear:(BOOL)animated;     // Called when the view has been fully transitioned onto the screen. Default does nothing
{
    if (self.busScheduleArray == nil)
    {
        [self getBusScheduleLocation];
        [self goToBusScheduleLocation];
        [self displayBusInfo];
        self.navigationItem.title = self.lineName;
    }
}

- (void)getBusScheduleLocation
{
    bool isMorning = true;
    if (self.workOrHomeSegment.selectedSegmentIndex == 0)
    {
        isMorning = true;
    }
    else
    {
        isMorning = false;
    }
/*    self.busScheduleArray = [BusLineOperator getBusLineSchedule:self.lineName morningOrNight:isMorning];
    
    [self.mapView removeAnnotations:[self.mapView annotations]];
    
    for (BusScheduleStopInfo* info in self.busScheduleArray) {
        //创建CLLocation 设置经纬度
        CLLocation *loc = [[CLLocation alloc]initWithLatitude:info.latitude longitude:info.longitude];
        CLLocationCoordinate2D coord = [loc coordinate];
        //创建标题
        NSString *titile = [NSString stringWithFormat:@"%@, %@",info.name,info.time];
        MarkPoint *markPoint = [[MarkPoint alloc] initWithCoordinate:coord andTitle:titile];
        //添加标注
        [self.mapView addAnnotation:markPoint];
    }*/
}

- (void)goToBusScheduleLocation
{
    if (self.busScheduleArray != nil && self.busScheduleArray.count > 0)
    {
        /*BusScheduleStopInfo* startInfo = [self.busScheduleArray objectAtIndex:0];
        BusScheduleStopInfo* endInfo = [self.busScheduleArray lastObject];
        double centerLatitude = (startInfo.latitude + endInfo.latitude)/2.0;
        double centerLongitude = (startInfo.longitude + endInfo.longitude)/2.0;
        CLLocation *centerLoc = [[CLLocation alloc]initWithLatitude:centerLatitude longitude:centerLongitude];
        
        CLLocation *startLoc = [[CLLocation alloc]initWithLatitude:startInfo.latitude longitude:startInfo.longitude];
        
        CLLocation *endLoc = [[CLLocation alloc]initWithLatitude:endInfo.latitude longitude:endInfo.longitude];
        
        CLLocationDistance meters =[startLoc distanceFromLocation:endLoc];
        
        CLLocationCoordinate2D loc = [centerLoc coordinate];
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(loc, meters * 1.4, meters * 1.4);
        [self.mapView setRegion:region animated:YES];*/
    }
}

- (void)displayBusInfo
{
/*    self.busInfo = [BusLineOperator getBusInfo:self.lineName];
    self.busInfoLabel.text = [NSString stringWithFormat:@"(%d seats) (%@ %@: %@)", self.busInfo.seatCount, self.busInfo.license, self.busInfo.driver, self.busInfo.phone];*/
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
    CLLocationCoordinate2D coord = [loc coordinate];
    //创建标题
    NSString *titile = [NSString stringWithFormat:@"%f,%f",coord.latitude,coord.longitude];
    MarkPoint *markPoint = [[MarkPoint alloc] initWithCoordinate:coord andTitle:titile];
    //添加标注
    [self.mapView addAnnotation:markPoint];
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
    [self getBusScheduleLocation];
    [self goToBusScheduleLocation];
}
@end
