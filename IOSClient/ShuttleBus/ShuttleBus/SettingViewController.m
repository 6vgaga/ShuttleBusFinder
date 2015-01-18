//
//  SettingViewController.m
//  ShuttleBus
//
//  Created by 刘威 on 12/8/14.
//  Copyright (c) 2014 TR. All rights reserved.
//

#import "SettingViewController.h"
#import "AppDelegate.h"
#import "DOPDropDownMenu.h"
#import "ShuttleAPI.h"

@interface SettingViewController ()

@end

@implementation SettingViewController

@synthesize revealController;
@synthesize busMenuArray;
@synthesize switchClickToUpload;
@synthesize frequenceText;
@synthesize fakeLineMenu;
@synthesize selectLine;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.frequenceText.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated     // Called when the view has been fully transitioned onto the screen. Default does nothing
{
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    self.frequenceText.text = [NSString stringWithFormat:@"%d", delegate.timerInterval];
    
    if (delegate.clickUpload == true)
    {
        [self.switchClickToUpload setOn:TRUE];
    }
    else
    {
        [self.switchClickToUpload setOn:FALSE];
    }
    
    if (delegate.busLineArry != nil)
    {
        NSMutableArray* tempArray = [[NSMutableArray alloc] init];
        for (BusInfo* info in delegate.busLineArry) {
            [tempArray addObject: NSLocalizedString(info->busLine, info->busLine)];
        }
        
        self.busMenuArray = [NSArray arrayWithArray:tempArray];
        
        DOPDropDownMenu *menu = [[DOPDropDownMenu alloc] initWithOrigin:self.fakeLineMenu.frame.origin andSize:self.fakeLineMenu.frame.size];
        menu.dataSource = self;
        menu.delegate = self;
        [self.view addSubview:menu];
    }
    
    self.selectLine = delegate.lineName;
    self.currentLine.text = delegate.lineName;
}

- (void)didReceiveMemoryWarning {
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

- (void)menu:(DOPDropDownMenu *)menu didSelectRowAtIndexPath:(DOPIndexPath *)indexPath {
    NSLog(@"column:%li row:%li", (long)indexPath.column, (long)indexPath.row);
    self.selectLine = [menu titleForRowAtIndexPath:indexPath];
    
    NSLog(@"%@", self.selectLine);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)showLeftMenu:(id)sender {
    [self.revealController toggleSidebar:!self.revealController.sidebarShowing duration:kGHRevealSidebarDefaultAnimationDuration];
}

- (IBAction)switchClickUpload:(id)sender {
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    if ([self.switchClickToUpload isOn])
    {
        delegate.clickUpload = true;
    }
    else
    {
        delegate.clickUpload = false;
    }
}
- (IBAction)applyFrequency:(id)sender {
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    delegate.timerInterval = [self.frequenceText.text intValue];
}
- (IBAction)applyYourLine:(id)sender {
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    delegate.lineName = self.selectLine;
    self.currentLine.text = delegate.lineName;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
@end
