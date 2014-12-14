//
//  ScheduleMapViewController.m
//  ShuttleBus
//
//  Created by 刘威 on 12/14/14.
//  Copyright (c) 2014 TR. All rights reserved.
//

#import "ScheduleMapViewController.h"
#import "MarkPoint.h"

@interface ScheduleMapViewController ()

@end

@implementation ScheduleMapViewController

@synthesize mapView, info;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (self.info != nil)
    {
        CLLocation *loc = [[CLLocation alloc]initWithLatitude:info->latitude longitude:info->longitude];
        CLLocationCoordinate2D coord = [loc coordinate];
        //创建标题
        NSString *titile = [NSString stringWithFormat:@"%@, %@",info->name,info->time];
        MarkPoint *markPoint = [[MarkPoint alloc] initWithCoordinate:coord andTitle:titile];
        //添加标注
        [self.mapView addAnnotation:markPoint];
        
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coord, 250, 250);
        [self.mapView setRegion:region animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
