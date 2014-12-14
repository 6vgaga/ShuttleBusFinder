//
//  HomeViewController.m
//  ShuttleBus
//
//  Created by LiuWeiMac on 8/16/14.
//  Copyright (c) 2014 TR. All rights reserved.
//

#import "HomeViewController.h"
#import "AppDelegate.h"
#import "BusInfoTableViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

@synthesize revealController;
@synthesize tableView;
@synthesize titleDataArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) reportError:(NSString *)errorMsg {
    NSLog(@"REST API call failed, error=%@",errorMsg);
}

-(NSInteger) getReturnedObjectArray: (NSArray*) objectArray {
    return 0;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Thomson Reuters Shuttle Bus";
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    //不要分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self initDataSource];
}

-(void)initDataSource
{
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    if (delegate.busLineArry == nil)
    {
        return;
    }
    
    NSMutableArray* tempArray = [[NSMutableArray alloc] init];
    for (BusInfo* info in delegate.busLineArry) {
        [tempArray addObject: info->busLine];
    }
    
    self.titleDataArray = [NSArray arrayWithArray:tempArray];
    
    return;
}

#pragma mark----tableViewDelegate
//返回几个表头
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.titleDataArray.count;
}

//设置表头的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 100;
}

//Section Footer的高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *string = [NSString stringWithFormat:@"%d",section];
    NSLog(string);
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //当前是第几个表头
    NSString *indexStr = [NSString stringWithFormat:@"%d",indexPath.section];
    NSLog(indexStr);
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 100)];
    view.backgroundColor = [UIColor whiteColor];
    
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    if (delegate.busLineArry == nil)
    {
        return nil;
    }
    
    BusInfo* info = [delegate.busLineArry objectAtIndex:section];
    
    UIImageView *photoImgView = [[UIImageView alloc]initWithFrame:CGRectMake(8, 11, 77, 77)];
    photoImgView.image = [UIImage imageNamed:@"busIcon.jpg"];
    [view addSubview:photoImgView];
    
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 3, 200, 25)];
    nameLabel.text = [NSString stringWithFormat:@"Driver: %@", info->driver];
    [view addSubview:nameLabel];
    
    UILabel *licLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 27, 200, 25)];
    licLabel.text = [NSString stringWithFormat:@"License: %@", info->license];
    [view addSubview:licLabel];
    
    UILabel *phoLable = [[UILabel alloc]initWithFrame:CGRectMake(100, 51, 200, 25)];
    phoLable.text = [NSString stringWithFormat:@"Phone: %@", info->phone];
    [view addSubview:phoLable];
    
    UILabel *scLable = [[UILabel alloc]initWithFrame:CGRectMake(100, 75, 200, 25)];
    scLable.text = [NSString stringWithFormat:@"SeatCount: %d", info->seatCount];
    [view addSubview:scLable];
    
    UILabel *numLable = [[UILabel alloc]initWithFrame:CGRectMake(8, 75, 70, 21)];
    numLable.text = info->busLine;
    [view addSubview:numLable];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(270, 25, 50, 50);
    [button setImage:[UIImage imageNamed:@"viewDetail.jpg"] forState:UIControlStateNormal];
    button.tag = section;
    [button addTarget:self action:@selector(doButton:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    
    UIImageView *lineImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 99, 320, 1)];
    lineImage.image = [UIImage imageNamed:@"line.png"];
    [view addSubview:lineImage];
    
    return view;
}

-(void)doButton:(UIButton *)sender
{
    //BusInfoViewController* svc=[[BusInfoViewController alloc]init];
    BusInfoTableViewController* svc = [self.storyboard instantiateViewControllerWithIdentifier:@"BusInfoTableViewController"];
    svc.busLine = [titleDataArray objectAtIndex:sender.tag];
    [self.navigationController pushViewController:svc animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

@end
