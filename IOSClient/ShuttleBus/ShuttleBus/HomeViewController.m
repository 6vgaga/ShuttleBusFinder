//
//  HomeViewController.m
//  ShuttleBus
//
//  Created by LiuWeiMac on 8/16/14.
//  Copyright (c) 2014 TR. All rights reserved.
//

#import "HomeViewController.h"
#import "AppDelegate.h"
#import "BusInfoViewController.h"

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
    return 40;
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
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, tableView.frame.size.width-20, 30)];
    titleLabel.text = [titleDataArray objectAtIndex:section];
    [view addSubview:titleLabel];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 320, 40);
    button.tag = 100+section;
    [button addTarget:self action:@selector(doButton:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    
    UIImageView *lineImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 39, 320, 1)];
    lineImage.image = [UIImage imageNamed:@"line.png"];
    [view addSubview:lineImage];
    
    return view;
}

-(void)doButton:(UIButton *)sender
{
    BusInfoViewController* svc=[[BusInfoViewController alloc]init];
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
