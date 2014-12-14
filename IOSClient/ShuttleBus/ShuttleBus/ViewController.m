//
//  ViewController.m
//  ShuttleBus
//
//  Created by LiuWeiMac on 8/16/14.
//  Copyright (c) 2014 TR. All rights reserved.
//

#import "ViewController.h"
#import "MenuListViewController.h"
#import "DOPDropDownMenu.h"
#import "AppDelegate.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize userName, password;

@synthesize busMenuArray;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    userName.delegate = self;
    password.delegate = self;
    
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    delegate.clickUpload = false;
}

- (void)viewDidAppear:(BOOL)animated;     // Called when the view has been fully transitioned onto the screen. Default does nothing
{
    if (self.busMenuArray == nil)
    {
        [self queryBusInfo];
    }
}

- (void)queryBusInfo
{
    void (^callbackFun) (NSArray*,bool)= ^ (NSArray* arrayObject,bool isError) {
        if (isError) {
            NSLog(@"failed to query location, err=%@",arrayObject.firstObject);
        }
        else
        {
            [self buildBusLineMenuList: arrayObject];
        }
    };
    RestRequestor* requstor= [[RestRequestor alloc]init];
    [requstor getAllBusline:callbackFun];
}

- (void)buildBusLineMenuList: (NSArray*) arrayObject
{
    if (arrayObject == nil) return;
    
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    delegate.busLineArry = [arrayObject copy];
    
    NSMutableArray* tempArray = [[NSMutableArray alloc] init];
    [tempArray addObject: NSLocalizedString(@"Select Line", @"Select Line")];
    for (BusInfo* info in arrayObject) {
        [tempArray addObject: NSLocalizedString(info->busLine, info->busLine)];
    }
    
    self.busMenuArray = [NSArray arrayWithArray:tempArray];
    
    DOPDropDownMenu *menu = [[DOPDropDownMenu alloc] initWithOrigin:self.fakeMenu.frame.origin andSize:self.fakeMenu.frame.size];
    menu.dataSource = self;
    menu.delegate = self;
    [self.view addSubview:menu];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)menu:(DOPDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column {
    if (self.busMenuArray != nil)
    {
        return self.busMenuArray.count;
    }
    else
    {
        return 0;
    }
}

- (NSString *)menu:(DOPDropDownMenu *)menu titleForRowAtIndexPath:(DOPIndexPath *)indexPath {
    switch (indexPath.column) {
        case 0: return self.busMenuArray[indexPath.row];
            break;
        default:
            return nil;
            break;
    }
}

- (IBAction)loginShuttleBus:(UIButton *)sender {
    if (self.userName.text == nil || self.userName.text.length == 0)
    {
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"Fail" message:@"Please input your User Name" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alter show];
        return;
    }
    
    if (self.password.text == nil || self.password.text.length == 0)
    {
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"Fail" message:@"Please input your Password" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alter show];
        return;
    }
    
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    
    if (delegate.lineName == nil || delegate.lineName.length == 0)
    {
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"Fail" message:@"Please select your bus line" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alter show];
        return;
    }
    
    delegate.userName = self.userName.text;
    // 获取菜单页面.
    MenuListViewController* menuVc = [self.storyboard instantiateViewControllerWithIdentifier:@"MenuListViewController"];
    NSLog(@"instantiateViewControllerWithIdentifier: %@", menuVc);
    if (nil==menuVc) return;
    
    // 直接模态弹出菜单页面（已废弃，仅用于调试）.
    if (NO) {
        menuVc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;    // 淡入淡出.
        [self presentModalViewController:menuVc animated:YES];
    }
    
    // 模态弹出侧开菜单控制器.
    if (YES) {
        //UIColor *bgColor = [UIColor colorWithRed:(50.0f/255.0f) green:(57.0f/255.0f) blue:(74.0f/255.0f) alpha:1.0f];
        UIColor *bgColor = [UIColor whiteColor];
        GHRevealViewController* revealController = [[GHRevealViewController alloc] initWithNibName:nil bundle:nil];
        revealController.view.backgroundColor = bgColor;
        
        // 绑定.
        menuVc.revealController = revealController;
        revealController.sidebarViewController = menuVc;
        
        // show.
        revealController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;    // 淡入淡出.
        [self presentModalViewController:revealController animated:YES];
    }
}

- (void)menu:(DOPDropDownMenu *)menu didSelectRowAtIndexPath:(DOPIndexPath *)indexPath {
    NSLog(@"column:%li row:%li", (long)indexPath.column, (long)indexPath.row);
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    if (indexPath.row == 0)
    {
        delegate.lineName = @"";
    }
    else
    {
        delegate.lineName = [menu titleForRowAtIndexPath:indexPath];
    }
    
    NSLog(@"%@", delegate.lineName);
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
@end
