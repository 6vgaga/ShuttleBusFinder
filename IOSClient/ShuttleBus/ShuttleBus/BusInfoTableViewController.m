//
//  BusInfoViewController.m
//  ShuttleBus
//
//  Created by 刘威 on 12/14/14.
//  Copyright (c) 2014 TR. All rights reserved.
//

#import "BusInfoTableViewController.h"
#import "JAActionButton.h"
#import "ScheduleMapViewController.h"

#define kBusInfoTableViewCellReuseIdentifier     @"BusInfoTableViewCellIdentifier"

#define kFlagButtonColor        [UIColor colorWithRed:255.0/255.0 green:150.0/255.0 blue:0/255.0 alpha:1]
#define kMoreButtonColor        [UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:1]
#define kArchiveButtonColor     [UIColor colorWithRed:60.0/255.0 green:112.0/255.0 blue:168/255.0 alpha:1]
#define kUnreadButtonColor      [UIColor colorWithRed:0/255.0 green:122.0/255.0 blue:255.0/255.0 alpha:1]

@interface BusInfoTableViewController ()

@end

@implementation BusInfoTableViewController

@synthesize tableData;
@synthesize busLine;
@synthesize busScheduleArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = self.busLine;
    
    [self queryBusSchedule];
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

- (void)queryBusSchedule
{
    void (^callbackFun) (NSArray*,bool)= ^ (NSArray* arrayObject,bool isError) {
        if (!isError)
        {
            if (arrayObject != nil && arrayObject.count > 0)
            {
                self.busScheduleArray = arrayObject;
                [self resetData];
            }
        }
        else
            NSLog(@"can't get ShuttleSchedule,err=", arrayObject.firstObject);
    };
    
    RestRequestor * req= [[RestRequestor alloc] init];
    [req getBusLineSchedule:self.busLine  callback:callbackFun];
}

- (void)resetData
{
    self.tableData = [[NSMutableArray alloc] init];
    for (BusScheduleStopInfo* info in self.busScheduleArray) {
        NSString *titile = [NSString stringWithFormat:@"%@, %@",info->name,info->time];
        [self.tableData addObject:titile];
    }
    
    [self.tableView reloadData];
    
    [self.tableView registerClass:[BusInfoTableViewCell class] forCellReuseIdentifier:kBusInfoTableViewCellReuseIdentifier];
}

- (NSArray *)leftButtons
{
    return nil;
}

- (NSArray *)rightButtons
{
    __typeof(self) __weak weakSelf = self;
    JAActionButton *button1 = [JAActionButton actionButtonWithTitle:@"View" color:kArchiveButtonColor handler:^(UIButton *actionButton, JASwipeCell*cell) {
        [cell completePinToTopViewAnimation];
        [weakSelf rightMostButtonSwipeCompleted:cell];
        NSLog(@"Right Button: View Pressed");
    }];
    
    JAActionButton *button2 = [JAActionButton actionButtonWithTitle:@"On Time" color:kFlagButtonColor handler:^(UIButton *actionButton, JASwipeCell*cell) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Flag" message:@"Have voted!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
        NSLog(@"Right Button: On Time Pressed");
    }];
    JAActionButton *button3 = [JAActionButton actionButtonWithTitle:@"Late" color:kMoreButtonColor handler:^(UIButton *actionButton, JASwipeCell*cell) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Flag" message:@"Have voted!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
        NSLog(@"Right Button: Late Pressed");
    }];
    
    return @[button1, button2, button3];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tableData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BusInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kBusInfoTableViewCellReuseIdentifier];
    
    [cell addActionButtons:[self leftButtons] withButtonWidth:kJAButtonWidth withButtonPosition:JAButtonLocationLeft];
    [cell addActionButtons:[self rightButtons] withButtonWidth:kJAButtonWidth withButtonPosition:JAButtonLocationRight];
    
    cell.delegate = self;
    
    [cell configureCellWithTitle:self.tableData[indexPath.row]];
    [cell setNeedsLayout];
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    
    return cell;
}

#pragma mark - UITableViewDelegate methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - JASwipeCellDelegate methods

- (void)swipingRightForCell:(JASwipeCell *)cell
{
    NSArray *indexPaths = [self.tableView indexPathsForVisibleRows];
    for (NSIndexPath *indexPath in indexPaths) {
        JASwipeCell *visibleCell = (JASwipeCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        if (visibleCell != cell) {
            [visibleCell resetContainerView];
        }
    }
}

- (void)swipingLeftForCell:(JASwipeCell *)cell
{
    NSArray *indexPaths = [self.tableView indexPathsForVisibleRows];
    for (NSIndexPath *indexPath in indexPaths) {
        JASwipeCell *visibleCell = (JASwipeCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        if (visibleCell != cell) {
            [visibleCell resetContainerView];
        }
    }
}

- (void)leftMostButtonSwipeCompleted:(JASwipeCell *)cell
{
    
}

- (void)rightMostButtonSwipeCompleted:(JASwipeCell *)cell
{
    ScheduleMapViewController* svc = [self.storyboard instantiateViewControllerWithIdentifier:@"ScheduleMapViewController"];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    svc.info = [self.busScheduleArray objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:svc animated:YES];
}

#pragma mark - UIScrollViewDelegate methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSArray *indexPaths = [self.tableView indexPathsForVisibleRows];
    for (NSIndexPath *indexPath in indexPaths) {
        JASwipeCell *cell = (JASwipeCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        [cell resetContainerView];
    }
}

@end
