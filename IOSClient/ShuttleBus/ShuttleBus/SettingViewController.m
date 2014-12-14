//
//  SettingViewController.m
//  ShuttleBus
//
//  Created by 刘威 on 12/8/14.
//  Copyright (c) 2014 TR. All rights reserved.
//

#import "SettingViewController.h"
#import "AppDelegate.h"

@interface SettingViewController ()

@end

@implementation SettingViewController

@synthesize revealController;

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
    self.frequenceText.text = [NSString stringWithFormat:@"%f", delegate.timerInterval];
    
    if (delegate.clickUpload == true)
    {
        [self.switchClickToUpload setOn:TRUE];
    }
    else
    {
        [self.switchClickToUpload setOn:FALSE];
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
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
@end
